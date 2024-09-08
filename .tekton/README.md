# Tekton CI/CD definitions

## preparations

export NAMESPACE=<namespace name>

envsubst <serviceaccount.yaml | kubectl apply -n $NAMESPACE -f -
envsubst <minio-credentials.yaml | kubectl apply -n $NAMESPACE -f -
envsubst <rpc-credentials.yaml | kubectl apply -n $NAMESPACE -f -
envsubst <ca-cert.yaml | kubectl apply -n $NAMESPACE -f -
envsubst <task-idx-btc.yaml | kubectl apply -n $NAMESPACE -f -


## Run pipeline

1. set parameters:
```sh
export STARTBLOCKHEIGHT=<num>
export NUMBLOCKS=<num>
```

2. `envsubst <task-idx-btc-run.yaml | kubectl create -n ${NAMESPACE} -f -`
