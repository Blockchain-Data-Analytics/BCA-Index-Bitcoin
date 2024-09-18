CREATE TABLE btc_block
(
    hash BYTEA NOT NULL,
    confirmations INTEGER,
    height INTEGER NOT NULL,
    version BIGINT NOT NULL,
    merkleroot BYTEA NOT NULL,
    "time" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    mediantime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    nonce BIGINT NOT NULL,
    difficulty NUMERIC NOT NULL,
    chainwork BYTEA NOT NULL,
    ntx INTEGER NOT NULL,
    previousblockhash BYTEA,
    nextblockhash BYTEA,
    strippedsize INTEGER NOT NULL,
    size INTEGER NOT NULL,
    weight INTEGER NOT NULL,
    bits VARCHAR NOT NULL
);

-- create primary key and indexes after data loading

