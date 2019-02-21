Line count files in a directory, e.g. lines of code:
```sh
find . -type f -name "*.go" -exec wc -l {} +
```
