  - address: ${external_address}
    user: rancher
    internal_address: ${internal_address}
    role:
      - controlplane
      - etcd
      - worker
