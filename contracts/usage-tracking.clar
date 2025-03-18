;; Usage Tracking Contract - Ultra Simplified

(define-data-var contract-owner principal tx-sender)

;; Simple ride data structure
(define-map rides
  { ride-id: (string-utf8 36) }
  {
    user-id: principal,
    bicycle-id: (string-utf8 36),
    start-time: uint,
    end-time: uint,
    is-active: bool,
    fee-paid: uint
  }
)

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-RIDE-EXISTS (err u101))
(define-constant ERR-RIDE-NOT-FOUND (err u102))
(define-constant ERR-RIDE-ALREADY-ENDED (err u103))

;; Start a new ride
(define-public (start-ride
    (ride-id (string-utf8 36))
    (bicycle-id (string-utf8 36)))
  (begin
    (asserts! (is-none (map-get? rides { ride-id: ride-id })) ERR-RIDE-EXISTS)

    (map-set rides
      { ride-id: ride-id }
      {
        user-id: tx-sender,
        bicycle-id: bicycle-id,
        start-time: block-height,
        end-time: u0,
        is-active: true,
        fee-paid: u0
      }
    )
    (ok ride-id)
  )
)

;; End a ride
(define-public (end-ride
    (ride-id (string-utf8 36))
    (fee-paid uint))
  (let ((ride (unwrap! (map-get? rides { ride-id: ride-id }) ERR-RIDE-NOT-FOUND)))
    (asserts! (is-eq tx-sender (get user-id ride)) ERR-NOT-AUTHORIZED)
    (asserts! (get is-active ride) ERR-RIDE-ALREADY-ENDED)

    (map-set rides
      { ride-id: ride-id }
      (merge ride {
        end-time: block-height,
        is-active: false,
        fee-paid: fee-paid
      })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-ride (ride-id (string-utf8 36)))
  (map-get? rides { ride-id: ride-id })
)

(define-read-only (is-ride-active (ride-id (string-utf8 36)))
  (match (map-get? rides { ride-id: ride-id })
    ride (get is-active ride)
    false
  )
)

