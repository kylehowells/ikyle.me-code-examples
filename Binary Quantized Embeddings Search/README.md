# Demo Semantic Text Search Using Binary Embeddings

This project demonstrates semantic text search using binary quantized embeddings for efficient storage and retrieval.

Blog post: [Binary Quantized Embeddings - How to use binary quantized embeddings for semantic text search](https://ikyle.me/blog/2025/binary-quantized-embeddings)

## Command Line Interface Usage

### Loading Text Segments

```bash
# Load with auto-generated ID
uv run rag.py load --text "This is a sample text to be stored in the database"

# Load with custom ID and metadata
uv run rag.py load --id "custom-id" --text "Another sample with a custom ID" --metadata '{"source": "example", "date": "2023-07-01"}'
```

### Searching for Similar Text

```bash
# Basic search with default limit (5 results)
python rag.py search "Find text similar to this query"

# Search with custom result limit
python rag.py search "Another search query" --limit 10
```

### Removing Segments

```bash
# Remove a segment by ID
python rag.py remove --id "custom-id"
```
