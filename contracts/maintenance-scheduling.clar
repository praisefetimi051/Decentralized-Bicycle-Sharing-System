;; Maintenance Scheduling Contract - Ultra Simplified

(define-data-var contract-owner principal tx-sender)

;; Simple maintenance record structure
(define-map maintenance-records
  { record-id: (string-utf8 36) }
  {
    bicycle-id: (string-utf8 36),
    scheduled-date: uint,
    completed-date: uint,
    is-completed: bool,
    technician: principal
  }
)

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-RECORD-EXISTS (err u101))
(define-constant ERR-RECORD-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-COMPLETED (err u103))

;; Schedule maintenance
(define-public (schedule-maintenance
    (record-id (string-utf8 36))
    (bicycle-id (string-utf8 36))
    (scheduled-date uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (asserts! (is-none (map-get? maintenance-records { record-id: record-id })) ERR-RECORD-EXISTS)

    (map-set maintenance-records
      { record-id: record-id }
      {
        bicycle-id: bicycle-id,
        scheduled-date: scheduled-date,
        completed-date: u0,
        is-completed: false,
        technician: tx-sender
      }
    )
    (ok record-id)
  )
)

;; Complete maintenance
(define-public (complete-maintenance
    (record-id (string-utf8 36)))
  (let ((record (unwrap! (map-get? maintenance-records { record-id: record-id }) ERR-RECORD-NOT-FOUND)))
    (asserts! (is-eq tx-sender (get technician record)) ERR-NOT-AUTHORIZED)
    (asserts! (not (get is-completed record)) ERR-ALREADY-COMPLETED)

    (map-set maintenance-records
      { record-id: record-id }
      (merge record {
        completed-date: block-height,
        is-completed: true
      })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-maintenance-record (record-id (string-utf8 36)))
  (map-get? maintenance-records { record-id: record-id })
)

(define-read-only (is-maintenance-completed (record-id (string-utf8 36)))
  (match (map-get? maintenance-records { record-id: record-id })
    record (get is-completed record)
    false
  )
)

