# Go Boilerplate

* [Cobra](https://github.com/spf13/cobra) CLI framework
* [Dep](https://github.com/golang/dep) for dependency management
* A two-stage Dockerfile for super slim images. See [this blog post from Hasura](https://blog.hasura.io/the-ultimate-guide-to-writing-dockerfiles-for-go-web-apps-336efad7012c/) for more Dockerfile ideas

```sh
make build
docker run --rm hello
docker run --rm hello hello --name "Max Power"
```
