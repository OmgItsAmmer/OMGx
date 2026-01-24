| table_name              | column_name               | data_type                   |
| ----------------------- | ------------------------- | --------------------------- |
| account_book            | account_book_id           | bigint                      |
| account_book            | entity_type               | character varying           |
| account_book            | entity_id                 | bigint                      |
| account_book            | entity_name               | character varying           |
| account_book            | transaction_type          | character varying           |
| account_book            | amount                    | numeric                     |
| account_book            | description               | text                        |
| account_book            | reference                 | character varying           |
| account_book            | transaction_date          | date                        |
| account_book            | created_at                | timestamp with time zone    |
| account_book            | updated_at                | timestamp with time zone    |
| account_book_summary    | entity_type               | character varying           |
| account_book_summary    | transaction_type          | character varying           |
| account_book_summary    | transaction_count         | bigint                      |
| account_book_summary    | total_amount              | numeric                     |
| account_book_summary    | average_amount            | numeric                     |
| account_book_summary    | min_amount                | numeric                     |
| account_book_summary    | max_amount                | numeric                     |
| account_book_summary    | earliest_transaction      | date                        |
| account_book_summary    | latest_transaction        | date                        |
| addresses               | address_id                | integer                     |
| addresses               | shipping_address          | text                        |
| addresses               | phone_number              | text                        |
| addresses               | postal_code               | text                        |
| addresses               | city                      | text                        |
| addresses               | country                   | text                        |
| addresses               | full_name                 | text                        |
| addresses               | customer_id               | integer                     |
| addresses               | vendor_id                 | integer                     |
| addresses               | salesman_id               | integer                     |
| addresses               | user_id                   | integer                     |
| addresses               | latitude                  | numeric                     |
| addresses               | longitude                 | numeric                     |
| addresses               | place_id                  | text                        |
| addresses               | formatted_address         | text                        |
| app_versions            | id                        | bigint                      |
| app_versions            | version                   | text                        |
| app_versions            | force_update              | boolean                     |
| app_versions            | redirect_url              | text                        |
| app_versions            | description               | text                        |
| app_versions            | created_at                | timestamp with time zone    |
| app_versions            | app_locked                | boolean                     |
| brands                  | brandname                 | text                        |
| brands                  | isVerified                | boolean                     |
| brands                  | isFeatured                | boolean                     |
| brands                  | brandID                   | integer                     |
| brands                  | product_count             | bigint                      |
| cart                    | cart_id                   | integer                     |
| cart                    | variant_id                | integer                     |
| cart                    | quantity                  | text                        |
| cart                    | customer_id               | integer                     |
| categories              | category_id               | integer                     |
| categories              | category_name             | text                        |
| categories              | isFeatured                | boolean                     |
| categories              | created_at                | timestamp with time zone    |
| categories              | product_count             | integer                     |
| collection_cart         | collection_cart_id        | integer                     |
| collection_cart         | customer_id               | integer                     |
| collection_cart         | collection_id             | integer                     |
| collection_cart         | created_at                | timestamp with time zone    |
| collection_cart         | updated_at                | timestamp with time zone    |
| collection_cart_items   | collection_cart_item_id   | integer                     |
| collection_cart_items   | collection_cart_id        | integer                     |
| collection_cart_items   | variant_id                | integer                     |
| collection_cart_items   | quantity                  | integer                     |
| collection_cart_items   | created_at                | timestamp with time zone    |
| collection_items        | collection_item_id        | integer                     |
| collection_items        | collection_id             | integer                     |
| collection_items        | variant_id                | integer                     |
| collection_items        | default_quantity          | integer                     |
| collection_items        | sort_order                | integer                     |
| collection_items        | created_at                | timestamp with time zone    |
| collection_items_detail | collection_item_id        | integer                     |
| collection_items_detail | collection_id             | integer                     |
| collection_items_detail | variant_id                | integer                     |
| collection_items_detail | default_quantity          | integer                     |
| collection_items_detail | sort_order                | integer                     |
| collection_items_detail | product_id                | integer                     |
| collection_items_detail | product_name              | text                        |
| collection_items_detail | product_description       | text                        |
| collection_items_detail | variant_name              | text                        |
| collection_items_detail | sell_price                | numeric                     |
| collection_items_detail | stock                     | integer                     |
| collection_items_detail | is_visible                | boolean                     |
| collection_items_detail | sku                       | character varying           |
| collection_items_detail | featured_image_id         | integer                     |
| collection_items_detail | image_url                 | text                        |
| collections             | collection_id             | integer                     |
| collections             | name                      | text                        |
| collections             | description               | text                        |
| collections             | image_url                 | text                        |
| collections             | is_active                 | boolean                     |
| collections             | is_featured               | boolean                     |
| collections             | display_order             | integer                     |
| collections             | created_at                | timestamp with time zone    |
| collections             | updated_at                | timestamp with time zone    |
| collections             | is_premium                | boolean                     |
| collections_summary     | collection_id             | integer                     |
| collections_summary     | name                      | text                        |
| collections_summary     | description               | text                        |
| collections_summary     | image_url                 | text                        |
| collections_summary     | is_active                 | boolean                     |
| collections_summary     | is_featured               | boolean                     |
| collections_summary     | is_premium                | boolean                     |
| collections_summary     | display_order             | integer                     |
| collections_summary     | created_at                | timestamp with time zone    |
| collections_summary     | updated_at                | timestamp with time zone    |
| collections_summary     | item_count                | bigint                      |
| collections_summary     | total_price               | numeric                     |
| customer_public_info    | customer_id               | integer                     |
| customer_public_info    | first_name                | text                        |
| customer_public_info    | last_name                 | text                        |
| customers               | customer_id               | integer                     |
| customers               | phone_number              | text                        |
| customers               | first_name                | text                        |
| customers               | last_name                 | text                        |
| customers               | cnic                      | text                        |
| customers               | email                     | text                        |
| customers               | created_at                | timestamp with time zone    |
| customers               | dob                       | timestamp with time zone    |
| customers               | gender                    | USER-DEFINED                |
| customers               | auth_uid                  | character varying           |
| customers               | fcm_token                 | text                        |
| customers               | token_version             | integer                     |
| expenses                | expense_id                | integer                     |
| expenses                | description               | text                        |
| expenses                | amount                    | numeric                     |
| expenses                | created_at                | timestamp with time zone    |
| extras                  | extraId                   | bigint                      |
| extras                  | AdminKey                  | text                        |
| guarantors              | first_name                | text                        |
| guarantors              | address                   | text                        |
| guarantors              | pfp                       | text                        |
| guarantors              | cnic                      | text                        |
| guarantors              | email                     | text                        |
| guarantors              | phone_number              | text                        |
| guarantors              | last_name                 | text                        |
| guarantors              | guarantor_id              | integer                     |
| image_entity            | image_entity_id           | integer                     |
| image_entity            | image_id                  | integer                     |
| image_entity            | entity_id                 | integer                     |
| image_entity            | entity_category           | text                        |
| image_entity            | created_at                | timestamp with time zone    |
| image_entity            | isFeatured                | boolean                     |
| image_entity            | updated_at                | timestamp with time zone    |
| images                  | filename                  | text                        |
| images                  | created_at                | timestamp with time zone    |
| images                  | image_url                 | text                        |
| images                  | image_id                  | integer                     |
| images                  | folderType                | text                        |
| installment_payments    | paid_date                 | timestamp with time zone    |
| installment_payments    | paid_amount               | text                        |
| installment_payments    | status                    | text                        |
| installment_payments    | sequence_no               | integer                     |
| installment_payments    | installment_plan_id       | integer                     |
| installment_payments    | due_date                  | timestamp with time zone    |
| installment_payments    | is_paid                   | boolean                     |
| installment_payments    | created_at                | timestamp without time zone |
| installment_payments    | amount_due                | text                        |
| installment_plans       | guarantor1_id             | integer                     |
| installment_plans       | installment_plans_id      | integer                     |
| installment_plans       | order_id                  | integer                     |
| installment_plans       | created_at                | timestamp with time zone    |
| installment_plans       | first_installment_date    | timestamp with time zone    |
| installment_plans       | guarantor2_id             | integer                     |
| installment_plans       | total_amount              | text                        |
| installment_plans       | down_payment              | text                        |
| installment_plans       | number_of_installments    | text                        |
| installment_plans       | document_charges          | text                        |
| installment_plans       | margin                    | text                        |
| installment_plans       | frequency_in_month        | text                        |
| installment_plans       | other_charges             | text                        |
| installment_plans       | duration                  | text                        |
| installment_plans       | note                      | text                        |
| installment_plans       | status                    | text                        |
| inventory_reservations  | reservation_id            | character varying           |
| inventory_reservations  | variant_id                | integer                     |
| inventory_reservations  | quantity                  | integer                     |
| inventory_reservations  | expires_at                | timestamp with time zone    |
| inventory_reservations  | created_at                | timestamp with time zone    |
| inventory_status        | variant_id                | integer                     |
| inventory_status        | product_name              | text                        |
| inventory_status        | variant_name              | text                        |
| inventory_status        | total_stock               | integer                     |
| inventory_status        | reserved_quantity         | bigint                      |
| inventory_status        | available_stock           | bigint                      |
| inventory_status        | sell_price                | numeric                     |
| invoice_coupons         | coupon_id                 | integer                     |
| invoice_coupons         | title                     | text                        |
| invoice_coupons         | coupon_code               | text                        |
| invoice_coupons         | discount_type             | text                        |
| invoice_coupons         | amount                    | numeric                     |
| invoice_coupons         | usage_limit               | integer                     |
| invoice_coupons         | used_count                | integer                     |
| invoice_coupons         | start_date                | timestamp with time zone    |
| invoice_coupons         | end_date                  | timestamp with time zone    |
| invoice_coupons         | is_active                 | boolean                     |
| invoice_coupons         | created_at                | timestamp with time zone    |
| kiosk_cart              | kiosk_id                  | integer                     |
| kiosk_cart              | kiosk_session_id          | uuid                        |
| kiosk_cart              | variant_id                | integer                     |
| kiosk_cart              | quantity                  | integer                     |
| kiosk_cart              | created_at                | timestamp without time zone |
| monthly_account_summary | month                     | timestamp with time zone    |
| monthly_account_summary | entity_type               | character varying           |
| monthly_account_summary | transaction_type          | character varying           |
| monthly_account_summary | transaction_count         | bigint                      |
| monthly_account_summary | total_amount              | numeric                     |
| notifications           | notification_id           | integer                     |
| notifications           | created_at                | timestamp with time zone    |
| notifications           | description               | text                        |
| notifications           | sub_description           | text                        |
| notifications           | isRead                    | boolean                     |
| notifications           | NotificationType          | text                        |
| notifications           | expires_at                | timestamp with time zone    |
| notifications           | order_id                  | integer                     |
| notifications           | installment_plan_id       | integer                     |
| notifications           | product_id                | integer                     |
| order_addresses         | order_address_id          | integer                     |
| order_addresses         | shipping_address          | text                        |
| order_addresses         | phone_number              | text                        |
| order_addresses         | postal_code               | text                        |
| order_addresses         | city                      | text                        |
| order_addresses         | country                   | text                        |
| order_addresses         | full_name                 | text                        |
| order_addresses         | customer_id               | integer                     |
| order_addresses         | vendor_id                 | integer                     |
| order_addresses         | salesman_id               | integer                     |
| order_addresses         | user_id                   | integer                     |
| order_addresses         | address_id                | integer                     |
| order_addresses         | latitude                  | numeric                     |
| order_addresses         | longitude                 | numeric                     |
| order_addresses         | place_id                  | text                        |
| order_addresses         | formatted_address         | text                        |
| order_items             | product_id                | integer                     |
| order_items             | price                     | numeric                     |
| order_items             | quantity                  | integer                     |
| order_items             | order_id                  | integer                     |
| order_items             | unit                      | character varying           |
| order_items             | total_buy_price           | numeric                     |
| order_items             | created_at                | timestamp with time zone    |
| order_items             | variant_id                | integer                     |
| orders                  | order_id                  | integer                     |
| orders                  | order_date                | date                        |
| orders                  | sub_total                 | numeric                     |
| orders                  | status                    | USER-DEFINED                |
| orders                  | saletype                  | text                        |
| orders                  | address_id                | integer                     |
| orders                  | paid_amount               | numeric                     |
| orders                  | buying_price              | numeric                     |
| orders                  | discount                  | numeric                     |
| orders                  | tax                       | numeric                     |
| orders                  | shipping_fee              | numeric                     |
| orders                  | user_id                   | integer                     |
| orders                  | customer_id               | integer                     |
| orders                  | idempotency_key           | character varying           |
| orders                  | payment_method            | USER-DEFINED                |
| orders                  | salesman_id               | integer                     |
| orders                  | salesman_comission        | integer                     |
| orders                  | shipping_method           | text                        |
| product_discounts       | discount_id               | integer                     |
| product_discounts       | product_id                | integer                     |
| product_discounts       | discount_type             | text                        |
| product_discounts       | amount                    | numeric                     |
| product_discounts       | start_date                | timestamp with time zone    |
| product_discounts       | end_date                  | timestamp with time zone    |
| product_discounts       | is_active                 | boolean                     |
| product_discounts       | created_at                | timestamp with time zone    |
| product_variants        | variant_id                | integer                     |
| product_variants        | product_id                | integer                     |
| product_variants        | buy_price                 | numeric                     |
| product_variants        | sell_price                | numeric                     |
| product_variants        | created_at                | timestamp with time zone    |
| product_variants        | updated_at                | timestamp with time zone    |
| product_variants        | sku                       | character varying           |
| product_variants        | variant_name              | text                        |
| product_variants        | is_visible                | boolean                     |
| product_variants        | stock                     | integer                     |
| product_variants        | alert_stock               | bigint                      |
| products                | product_id                | integer                     |
| products                | name                      | text                        |
| products                | description               | text                        |
| products                | base_price                | text                        |
| products                | sale_price                | text                        |
| products                | category_id               | integer                     |
| products                | ispopular                 | boolean                     |
| products                | stock_quantity            | integer                     |
| products                | created_at                | timestamp with time zone    |
| products                | brandID                   | integer                     |
| products                | alert_stock               | integer                     |
| products                | isVisible                 | boolean                     |
| products                | tag                       | USER-DEFINED                |
| products                | price_range               | text                        |
| purchase_items          | purchase_item_id          | bigint                      |
| purchase_items          | purchase_id               | bigint                      |
| purchase_items          | product_id                | bigint                      |
| purchase_items          | variant_id                | bigint                      |
| purchase_items          | price                     | numeric                     |
| purchase_items          | quantity                  | integer                     |
| purchase_items          | unit                      | character varying           |
| purchase_items          | created_at                | timestamp with time zone    |
| purchases               | purchase_id               | bigint                      |
| purchases               | purchase_date             | date                        |
| purchases               | sub_total                 | numeric                     |
| purchases               | status                    | character varying           |
| purchases               | address_id                | bigint                      |
| purchases               | paid_amount               | numeric                     |
| purchases               | vendor_id                 | bigint                      |
| purchases               | discount                  | numeric                     |
| purchases               | tax                       | numeric                     |
| purchases               | shipping_fee              | numeric                     |
| purchases               | created_at                | timestamp with time zone    |
| purchases               | updated_at                | timestamp with time zone    |
| purchases               | user_id                   | integer                     |
| reviews                 | review_id                 | bigint                      |
| reviews                 | product_id                | integer                     |
| reviews                 | sent_at                   | timestamp with time zone    |
| reviews                 | review                    | text                        |
| reviews                 | rating                    | numeric                     |
| reviews                 | customer_id               | integer                     |
| salesman                | phone_number              | text                        |
| salesman                | email                     | text                        |
| salesman                | last_name                 | text                        |
| salesman                | cnic                      | text                        |
| salesman                | city                      | text                        |
| salesman                | first_name                | text                        |
| salesman                | salesman_id               | integer                     |
| salesman                | area                      | text                        |
| salesman                | pfp                       | text                        |
| salesman                | created_at                | timestamp with time zone    |
| salesman                | comission                 | integer                     |
| security_audit_log      | log_id                    | integer                     |
| security_audit_log      | event_type                | character varying           |
| security_audit_log      | event_data                | jsonb                       |
| security_audit_log      | timestamp                 | timestamp with time zone    |
| security_audit_log      | ip_address                | inet                        |
| security_audit_log      | user_agent                | text                        |
| security_audit_log      | customer_id               | integer                     |
| security_audit_log      | severity                  | character varying           |
| security_dashboard      | date                      | date                        |
| security_dashboard      | event_type                | character varying           |
| security_dashboard      | severity                  | character varying           |
| security_dashboard      | event_count               | bigint                      |
| security_dashboard      | unique_customers          | bigint                      |
| shop                    | shop_id                   | integer                     |
| shop                    | shopname                  | text                        |
| shop                    | taxrate                   | numeric                     |
| shop                    | shipping_price            | numeric                     |
| shop                    | threshold_free_shipping   | numeric                     |
| shop                    | software_company_name     | text                        |
| shop                    | software_website_link     | text                        |
| shop                    | software_contact_no       | text                        |
| shop                    | is_shipping_enable        | boolean                     |
| shop                    | max_allowed_item_quantity | bigint                      |
| users                   | first_name                | text                        |
| users                   | last_name                 | text                        |
| users                   | phone_number              | text                        |
| users                   | email                     | text                        |
| users                   | dob                       | timestamp with time zone    |
| users                   | created_at                | timestamp with time zone    |
| users                   | gender                    | USER-DEFINED                |
| users                   | user_id                   | integer                     |
| users                   | auth_uid                  | character varying           |
| vendors                 | vendor_id                 | integer                     |
| vendors                 | phone_number              | text                        |
| vendors                 | first_name                | text                        |
| vendors                 | last_name                 | text                        |
| vendors                 | cnic                      | text                        |
| vendors                 | email                     | text                        |
| vendors                 | created_at                | timestamp with time zone    |
| wishlist                | wishlist_id               | bigint                      |
| wishlist                | created_at                | timestamp with time zone    |
| wishlist                | product_id                | integer                     |
| wishlist                | customer_id               | integer                     |