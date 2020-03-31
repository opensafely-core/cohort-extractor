docker run -it --rm --mount source=$(pwd),dst=/workspace,type=bind stata

Analysis must be at /workspace/analysis/model.do
Data must be at /workspace/analysis/input.csv
