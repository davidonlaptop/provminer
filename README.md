# ProvMiner
A collection of scripts to manage experimentation provenance

## File Collector
Use this utility to extract the file metadata from your experiments. You can pass as many directory as needed.

```bash
./fileminer.sh path1 [,path2 [,path3 [,...]]]
```

eg:
```bash
./fileminer.sh $HOME /etc
```