FROM golang:1.16.6-buster as builder

WORKDIR /srv/app/
COPY . .
RUN go build 

FROM debian:buster-slim

WORKDIR /srv/app/
COPY --from=builder /srv/app/app .

CMD ["./app"]
