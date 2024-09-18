CREATE TABLE btc_transaction
(
    txid BYTEA NOT NULL,
    txhash BYTEA,
    blockhash BYTEA NOT NULL,
    blocktime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    version BIGINT NOT NULL,
    size INTEGER NOT NULL,
    vsize INTEGER NOT NULL,
    weight INTEGER NOT NULL,
    locktime BIGINT NOT NULL,
    fee NUMERIC,
    sumins NUMERIC,
    sumouts NUMERIC,
    vin JSON,
    vout JSON
);

