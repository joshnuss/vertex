CREATE TABLE metrics (
  project String,
  tenant String,
  event String,
  tags Array(String),
  inserted_at timestamp DEFAULT now()
) ENGINE MergeTree
ORDER BY inserted_at
