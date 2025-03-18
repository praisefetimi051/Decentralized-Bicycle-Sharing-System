;; User Verification Contract - Ultra Simplified

(define-data-var contract-owner principal tx-sender)

;; Verification level constants
(define-constant LEVEL-NONE u0)
(define-constant LEVEL-BASIC u1)
(define-constant LEVEL-VERIFIED u2)

;; Simple user data structure
(define-map users
  { user-id: principal }
  {
    verification-level: uint,
    registration-date: uint,
    deposit-amount: uint
  }
)

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-USER-EXISTS (err u101))
(define-constant ERR-USER-NOT-FOUND (err u102))

;; Register a new user
(define-public (register-user)
  (begin
    (asserts! (is-none (map-get? users { user-id: tx-sender })) ERR-USER-EXISTS)

    (map-set users
      { user-id: tx-sender }
      {
        verification-level: LEVEL-NONE,
        registration-date: block-height,
        deposit-amount: u0
      }
    )
    (ok tx-sender)
  )
)

;; Update user verification level
(define-public (update-verification-level
    (user-id principal)
    (new-level uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? users { user-id: user-id })) ERR-USER-NOT-FOUND)

    (let ((user (unwrap! (map-get? users { user-id: user-id }) ERR-USER-NOT-FOUND)))
      (map-set users
        { user-id: user-id }
        (merge user { verification-level: new-level })
      )
    )
    (ok true)
  )
)

;; Add deposit
(define-public (add-deposit
    (amount uint))
  (let ((user (unwrap! (map-get? users { user-id: tx-sender }) ERR-USER-NOT-FOUND)))
    (map-set users
      { user-id: tx-sender }
      (merge user { deposit-amount: (+ (get deposit-amount user) amount) })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-user (user-id principal))
  (map-get? users { user-id: user-id })
)

(define-read-only (is-user-verified (user-id principal))
  (match (map-get? users { user-id: user-id })
    user (>= (get verification-level user) LEVEL-BASIC)
    false
  )
)

