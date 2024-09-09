CREATE TABLE IF NOT EXISTS public.btc_transaction
(
    txid bytea NOT NULL,
    txhash bytea,
    blockhash bytea NOT NULL,
    blocktime timestamp without time zone NOT NULL,
    version integer NOT NULL,
    size integer NOT NULL,
    vsize integer NOT NULL,
    weight integer NOT NULL,
    locktime bigint NOT NULL,
    fee numeric,
    sumins numeric,
    sumouts numeric,
    vin jsonb,
    vout jsonb,
    CONSTRAINT btc_transaction_pkey PRIMARY KEY (txid)
)
