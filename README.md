# ProvMiner
A collection of scripts to manage experimentation provenance

## File Collector
Use this utility to extract the file metadata from your experiments. You can pass as many directory as needed.

```bash
sudo ./fileminer.sh path1 [,path2 [,path3 [,...]]]
```

eg: to scan both your home directory AND `/etc`, run:
```bash
sudo ./fileminer.sh $HOME /etc
```

IMPORTANT: use sudo to make sure the script has the proper permissions to scan the directory.

WARNING: You need approximately 200 MB of free space to scan 1 million files.
