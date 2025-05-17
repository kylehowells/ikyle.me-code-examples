# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "sqlite-vec",
#     "sentence-transformers",
# ]
# ///
# https://docs.astral.sh/uv/guides/scripts/

import os
import sqlite3
import uuid
import sqlite_vec
from sentence_transformers import SentenceTransformer
from typing import List, Tuple
import json

class RAG:
    """Semantic text search for Retrieval Augmented Generation"""
    
    def __init__(self, db_path: str = None):
        """Initialize the RAG system.
        
        Args:
            db_path: Path to the SQLite database file
        """
        self.db_path = os.path.join(os.path.dirname(__file__), "rag.db") if db_path is None else db_path
        self._init_db()
        # Initialize the embedding model
        self.model = SentenceTransformer('mixedbread-ai/mxbai-embed-large-v1')
    
    def _init_db(self) -> None:
        """Initialize the SQLite database with required tables."""
        conn = sqlite3.connect(self.db_path)
        conn.enable_load_extension(True)
        sqlite_vec.load(conn)
        conn.enable_load_extension(False)
        
        # Create virtual table for vector storage with binary embeddings
        conn.execute("""
            CREATE VIRTUAL TABLE IF NOT EXISTS segments 
            USING vec0(
                id TEXT PRIMARY KEY,       -- Segment ID
                text TEXT,                 -- Segment text
                embedding bit[1024],       -- Binary quantized embedding vector
                metadata TEXT              -- Optional metadata in JSON format
            )
        """)
        
        conn.commit()
        conn.close()
    
    def _get_db_connection(self) -> sqlite3.Connection:
        """Get a database connection with sqlite-vec extension loaded."""
        conn = sqlite3.connect(self.db_path)
        conn.enable_load_extension(True)
        sqlite_vec.load(conn)
        conn.enable_load_extension(False)
        return conn
    
    def load_segment(self, id: str, text: str, metadata: str = "{}") -> None:
        """Load a segment into the database.
        
        Args:
            id: Unique identifier for the segment
            text: The text content
            metadata: Optional JSON metadata string
        """
        if not text or len(text.strip()) == 0:
            return

        # Generate embedding using SentenceTransformer
        embedding = self.model.encode(text, normalize_embeddings=True)
        # Convert embedding to JSON string for SQLite-Vec's vec_quantize_binary function
        embedding_json = json.dumps(embedding.tolist())
        
        # Store in database using vec_quantize_binary
        conn = self._get_db_connection()
        
        conn.execute("""
            INSERT OR REPLACE INTO segments (id, text, embedding, metadata)
            VALUES (?, ?, vec_quantize_binary(?), ?)
        """, (id, text, embedding_json, metadata))
        
        conn.commit()
        conn.close()
    
    def search_segments(self, text: str, limit: int = 10) -> List[Tuple[str, str, float, str]]:
        """Search for segments similar to the given text.
        
        Args:
            text: The text to search for
            limit: Maximum number of results to return
            
        Returns:
            List of tuples containing (id, text, similarity_score, metadata)
        """
        # Generate embedding for query text
        query_embedding = self.model.encode(text, normalize_embeddings=True)
        # Convert query embedding to JSON string
        query_embedding_json = str(query_embedding.tolist())
        
        # Search database using vec_quantize_binary for the query
        conn = self._get_db_connection()
        
        cursor = conn.execute("""
            SELECT id, text, distance, metadata 
            FROM segments 
            WHERE embedding MATCH vec_quantize_binary(?) AND k = ?
            ORDER BY distance
        """, (query_embedding_json, limit))
        
        results = []
        for id, text, distance, metadata in cursor.fetchall():
            # Convert distance to similarity score (normalize to [0,1] range)
            # The distance is a Hamming distance between binary vectors
            similarity = 1.0 - (distance / 1024.0)  # 1024 is our vector dimension
            results.append((id, text, similarity, metadata))
        
        conn.close()
        
        return results
    
    def remove_segment(self, id: str) -> None:
        """Remove a segment from the database.
        
        Args:
            id: The ID of the segment to remove
        """
        conn = self._get_db_connection()
        conn.execute("DELETE FROM segments WHERE id = ?", (id,))
        conn.commit()
        conn.close()


# MARK: - Command Line Interface

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Retrieval Augmented Generation (RAG) CLI")
    subparsers = parser.add_subparsers(dest="command", help="Command to run")
    
    # Load text command
    load_parser = subparsers.add_parser("load", help="Load a text segment into the database")
    load_parser.add_argument("--id", "-i", default="<default>", help="ID to save this text segment under")
    load_parser.add_argument("--text", "-t", required=True, help="The text to be saved")
    load_parser.add_argument("--metadata", "-m", default="{}", help="Optional JSON metadata")
    
    # Remove text segment with ID
    remove_parser = subparsers.add_parser("remove", help="Remove a text segment from the database")
    remove_parser.add_argument("--id", "-i", required=True, help="The ID of the text segment to be removed")
    
    # Search command
    search_parser = subparsers.add_parser("search", help="Search for text in the loaded segments")
    search_parser.add_argument("query", help="Text to search for")
    search_parser.add_argument("--limit", "-n", type=int, default=5, help="Maximum number of results (default: 5)")
    
    args = parser.parse_args()
    
    # Initialize RAG
    rag = RAG()
    
    if args.command == "load":
        if not args.text:
            print("Error: Text is required. Use --text to provide text content.")
        else:
            if args.id == "<default>":
                args.id = str(uuid.uuid4())
            rag.load_segment(args.id, args.text, args.metadata)
            print(f"Loaded text segment with ID: {args.id}")
    elif args.command == "remove":
        if not args.id:
            print("Error: ID is required. Use --id to specify which segment to remove.")
        else:
            rag.remove_segment(args.id)
            print(f"Removed text segment with ID: {args.id}")
    elif args.command == "search":
        results = rag.search_segments(args.query, args.limit)
        print(f"Found {len(results)} results:")
        for i, (segment_id, text, similarity, metadata) in enumerate(results, 1):
            print(f"\n{i}. [{segment_id}] (similarity: {similarity:.4f})")
            print(f"   '{text}'")
            if metadata and metadata != "{}":
                print(f"   Metadata: {metadata}")
    else:
        parser.print_help()

