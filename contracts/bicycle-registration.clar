;; Bicycle Registration Contract - Ultra Simplified
;; Uses uint for status instead of strings to avoid type issues

(define-data-var contract-owner principal tx-sender)

;; Status constants (using uint instead of strings)
(define-constant STATUS-AVAILABLE u1)
(define-constant STATUS-IN-USE u2)
(define-constant STATUS-MAINTENANCE u3)
(define-constant STATUS-RETIRED u4)

;; Ultra simple bicycle data structure
(define-map bicycles
  { bicycle-id: (string-utf8 36) }
  {
    owner: principal,
    status: uint,
    hourly-rate: uint,
    registration-date: uint
  }
)

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-BICYCLE-EXISTS (err u101))
(define-constant ERR-BICYCLE-NOT-FOUND (err u102))

;; Register a new bicycle
(define-public (register-bicycle
    (bicycle-id (string-utf8 36))
    (hourly-rate uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (asserts! (is-none (map-get? bicycles { bicycle-id: bicycle-id })) ERR-BICYCLE-EXISTS)

    (map-set bicycles
      { bicycle-id: bicycle-id }
      {
        owner: tx-sender,
        status: STATUS-AVAILABLE,
        hourly-rate: hourly-rate,
        registration-date: block-height
      }
    )
    (ok bicycle-id)
  )
)

;; Update bicycle status
(define-public (update-bicycle-status
    (bicycle-id (string-utf8 36))
    (new-status uint))
  (let ((bicycle (unwrap! (map-get? bicycles { bicycle-id: bicycle-id }) ERR-BICYCLE-NOT-FOUND)))
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)

    (map-set bicycles
      { bicycle-id: bicycle-id }
      (merge bicycle { status: new-status })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-bicycle (bicycle-id (string-utf8 36)))
  (map-get? bicycles { bicycle-id: bicycle-id })
)

(define-read-only (is-bicycle-available (bicycle-id (string-utf8 36)))
  (match (map-get? bicycles { bicycle-id: bicycle-id })
    bicycle (is-eq (get status bicycle) STATUS-AVAILABLE)
    false
  )
)

