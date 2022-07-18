# pschmitt/debug

## Usage

### Docker 

```shell
docker run -it --rm pschmitt/debug
```

### Kubernetes

```shell
kubectl run -it --rm --image pschmitt/debug "debug-${USER}-$(date '+%s')"
```
