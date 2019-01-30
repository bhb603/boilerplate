FROM golang:1.11 AS builder

WORKDIR /go/src/github.com/bhb603/hello

# only required when using dep for dependency management
RUN go get -u github.com/golang/dep/cmd/dep
COPY Gopkg.* ./
RUN dep ensure -vendor-only

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /bin/hello main.go

FROM alpine:latest
COPY --from=builder /bin/hello /bin/hello
CMD ["/bin/hello"]
