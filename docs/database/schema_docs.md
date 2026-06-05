    | source_table           | source_column       | target_table      | target_column        | constraint_name                               | on_delete_action |
| ---------------------- | ------------------- | ----------------- | -------------------- | --------------------------------------------- | ---------------- |
| addresses              | vendor_id           | vendors           | vendor_id            | addresses_vendor_id_fkey                      | CASCADE          |
| addresses              | customer_id         | customers         | customer_id          | addresses_customer_id_fkey                    | CASCADE          |
| addresses              | user_id             | users             | user_id              | addresses_user_id_fkey                        | CASCADE          |
| addresses              | salesman_id         | salesman          | salesman_id          | addresses_salesman_id_fkey                    | CASCADE          |
| cart                   | variant_id          | product_variants  | variant_id           | cart_variant_id_fkey                          | CASCADE          |
| cart                   | customer_id         | customers         | customer_id          | cart_customer_id_fkey                         | CASCADE          |
| collection_cart        | customer_id         | customers         | customer_id          | collection_cart_customer_id_fkey              | CASCADE          |
| collection_cart        | collection_id       | collections       | collection_id        | collection_cart_collection_id_fkey            | CASCADE          |
| collection_cart_items  | collection_cart_id  | collection_cart   | collection_cart_id   | collection_cart_items_collection_cart_id_fkey | CASCADE          |
| collection_cart_items  | variant_id          | product_variants  | variant_id           | collection_cart_items_variant_id_fkey         | CASCADE          |
| collection_items       | collection_id       | collections       | collection_id        | collection_items_collection_id_fkey           | CASCADE          |
| collection_items       | variant_id          | product_variants  | variant_id           | collection_items_variant_id_fkey              | CASCADE          |
| image_entity           | image_id            | images            | image_id             | image_entity_image_id_fkey                    | CASCADE          |
| installment_payments   | installment_plan_id | installment_plans | installment_plans_id | installment_payments_installment_plan_id_fkey | CASCADE          |
| installment_plans      | order_id            | orders            | order_id             | installment_plans_order_id_fkey               | CASCADE          |
| installment_plans      | guarantor2_id       | guarantors        | guarantor_id         | installment_plans_guarantor2_id_fkey          | SET NULL         |
| installment_plans      | guarantor1_id       | guarantors        | guarantor_id         | installment_plans_guarantor1_id_fkey          | SET NULL         |
| inventory_reservations | variant_id          | product_variants  | variant_id           | inventory_reservations_variant_id_fkey        | CASCADE          |
| kiosk_cart             | variant_id          | product_variants  | variant_id           | kiosk_cart_variant_id_fkey                    | CASCADE          |
| notifications          | order_id            | orders            | order_id             | notifications_order_id_fkey                   | CASCADE          |
| notifications          | installment_plan_id | installment_plans | installment_plans_id | notifications_installment_plan_id_fkey        | CASCADE          |
| notifications          | product_id          | products          | product_id           | notifications_product_id_fkey                 | CASCADE          |
| order_addresses        | address_id          | addresses         | address_id           | order_addresses_address_id_fkey               | SET NULL         |
| order_addresses        | customer_id         | customers         | customer_id          | order_addresses_customer_id_fkey              | CASCADE          |
| order_addresses        | salesman_id         | salesman          | salesman_id          | order_addresses_salesman_id_fkey              | CASCADE          |
| order_addresses        | user_id             | users             | user_id              | order_addresses_user_id_fkey                  | CASCADE          |
| order_addresses        | vendor_id           | vendors           | vendor_id            | order_addresses_vendor_id_fkey                | CASCADE          |
| order_items            | product_id          | products          | product_id           | order_items_product_id_fkey                   | RESTRICT         |
| order_items            | order_id            | orders            | order_id             | order_items_order_id_fkey                     | CASCADE          |
| orders                 | salesman_id         | salesman          | salesman_id          | orders_salesman_id_fkey                       | SET NULL         |
| orders                 | user_id             | users             | user_id              | orders_user_id_fkey                           | CASCADE          |
| orders                 | customer_id         | customers         | customer_id          | orders_customer_id_fkey                       | SET NULL         |
| orders                 | address_id          | addresses         | address_id           | orders_address_id_fkey                        | SET NULL         |
| product_discounts      | product_id          | products          | product_id           | product_discounts_product_id_fkey             | CASCADE          |
| product_variants       | product_id          | products          | product_id           | fk_product                                    | CASCADE          |
| products               | category_id         | categories        | category_id          | products_category_id_fkey                     | SET DEFAULT      |
| products               | brandID             | brands            | brandID              | products_brandID_fkey                         | SET DEFAULT      |
| purchase_items         | product_id          | products          | product_id           | purchase_items_product_id_fkey                | RESTRICT         |
| purchase_items         | purchase_id         | purchases         | purchase_id          | purchase_items_purchase_id_fkey               | CASCADE          |
| purchases              | vendor_id           | vendors           | vendor_id            | purchases_vendor_id_fkey                      | NO ACTION        |
| purchases              | user_id             | users             | user_id              | purchases_user_id_fkey                        | CASCADE          |
| purchases              | address_id          | addresses         | address_id           | purchases_address_id_fkey                     | RESTRICT         |
| reviews                | product_id          | products          | product_id           | reviews_product_id_fkey                       | CASCADE          |
| reviews                | customer_id         | customers         | customer_id          | reviews_customer_id_fkey                      | CASCADE          |
| wishlist               | product_id          | products          | product_id           | wishlist_product_id_fkey                      | CASCADE          |
| wishlist               | customer_id         | customers         | customer_id          | wishlist_customer_id_fkey                     | CASCADE          |