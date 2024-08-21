(lang dune 3.0)

(name index_btc)

(generate_opam_files true)

(source
 (github Blockchain-Data-Analytics/index_btc))

(authors "Alexander Diemand <codieplusplus@apax.net>")

(maintainers "Alexander Diemand <codieplusplus@apax.net>")

(license LICENSE)

(package
 (name index_btc)
 (synopsis "indexing the BTC blockchain")
 (description "Tools to automatically extract information from the Bitcoin blockchain and add it to a relational database")
 (depends ocaml dune)
)

