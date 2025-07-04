import 'package:ecommerce_dashboard/Models/entity/entity_model.dart';
import 'package:ecommerce_dashboard/controllers/report/report_controller.dart';
import 'package:ecommerce_dashboard/controllers/customer/customer_controller.dart';
import 'package:ecommerce_dashboard/controllers/vendor/vendor_controller.dart';
import 'package:ecommerce_dashboard/controllers/salesman/salesman_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/common/widgets/dropdown_search/enhanced_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AccountBookReportDialog extends StatefulWidget {
  const AccountBookReportDialog({super.key});

  @override
  State<AccountBookReportDialog> createState() =>
      _AccountBookReportDialogState();
}

class _AccountBookReportDialogState extends State<AccountBookReportDialog> {
  final reportController = ReportController.instance;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final entitySearchController = TextEditingController();

  // Observables
  final selectedEntityType = EntityType.customer.obs;
  final selectedEntity = Rx<EntityModel?>(null);
  final isLoadingEntities = false.obs;
  final availableEntities = <EntityModel>[].obs;

  // Date range
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    loadEntitiesForCurrentType();

    // Listen to entity type changes
    ever(selectedEntityType, (_) => loadEntitiesForCurrentType());
  }

  @override
  void dispose() {
    entitySearchController.dispose();
    super.dispose();
  }

  /// Load entities based on currently selected entity type
  Future<void> loadEntitiesForCurrentType() async {
    try {
      isLoadingEntities.value = true;
      selectedEntity.value = null;
      entitySearchController.clear();

      List<EntityModel> entities = [];

      switch (selectedEntityType.value) {
        case EntityType.customer:
          final customerController = Get.find<CustomerController>();
          await customerController.fetchAllCustomers();
          entities = customerController.allCustomers
              .map((customer) => EntityModel.fromCustomer(customer))
              .toList();
          break;
        case EntityType.vendor:
          final vendorController = Get.find<VendorController>();
          await vendorController.fetchAllVendors();
          entities = vendorController.allVendors
              .map((vendor) => EntityModel.fromVendor(vendor))
              .toList();
          break;
        case EntityType.salesman:
          final salesmanController = Get.find<SalesmanController>();
          await salesmanController.fetchAllSalesman();
          entities = salesmanController.allSalesman
              .map((salesman) => EntityModel.fromSalesman(salesman))
              .toList();
          break;
        case EntityType.user:
          entities = [];
          break;
      }

      availableEntities.assignAll(entities);
    } catch (e) {
      // Handle error silently or show snackbar
    } finally {
      isLoadingEntities.value = false;
    }
  }

  /// Handle entity selection
  void onEntitySelected(EntityModel? entity) {
    selectedEntity.value = entity;
    if (entity != null) {
      String display = entity.name;
      if (entity.phoneNumber != null && entity.phoneNumber!.isNotEmpty) {
        display += ' - ${entity.phoneNumber}';
      }
      entitySearchController.text = display;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account Book Report by Entity',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Entity Type Dropdown
                    Obx(() => DropdownButtonFormField<EntityType>(
                          value: selectedEntityType.value,
                          decoration: const InputDecoration(
                            labelText: 'Entity Type *',
                            prefixIcon: Icon(Iconsax.category),
                          ),
                          validator: (value) => value == null
                              ? 'Please select entity type'
                              : null,
                          items: EntityType.values
                              .where((type) => type != EntityType.user)
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type
                                        .toString()
                                        .split('.')
                                        .last
                                        .capitalize!),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              selectedEntityType.value = value;
                            }
                          },
                        )),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Entity Selection Autocomplete
                    Obx(() => Container(
                          child: isLoadingEntities.value
                              ? Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: TColors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Loading ${selectedEntityType.value.toString().split('.').last.toLowerCase()}s...',
                                        style: const TextStyle(
                                            color: TColors.darkGrey),
                                      ),
                                    ],
                                  ),
                                )
                              : availableEntities.isEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: TColors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Iconsax.info_circle,
                                              color: TColors.warning, size: 16),
                                          const SizedBox(width: 8),
                                          Text(
                                            'No ${selectedEntityType.value.toString().split('.').last.toLowerCase()}s found',
                                            style: const TextStyle(
                                                color: TColors.darkGrey),
                                          ),
                                        ],
                                      ),
                                    )
                                  : EnhancedAutocomplete<EntityModel>(
                                      labelText:
                                          '${selectedEntityType.value.toString().split('.').last.capitalize!} *',
                                      hintText:
                                          'Search and select a ${selectedEntityType.value.toString().split('.').last.toLowerCase()}',
                                      displayStringForOption: (entity) {
                                        String display = entity.name;
                                        if (entity.phoneNumber != null &&
                                            entity.phoneNumber!.isNotEmpty) {
                                          display += ' - ${entity.phoneNumber}';
                                        }
                                        return display;
                                      },
                                      options: availableEntities,
                                      externalController:
                                          entitySearchController,
                                      showOptionsOnFocus: true,
                                      getItemId: (entity) => entity.id,
                                      onSelected: onEntitySelected,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a ${selectedEntityType.value.toString().split('.').last.toLowerCase()}';
                                        }
                                        bool isValid =
                                            availableEntities.any((entity) {
                                          String display = entity.name;
                                          if (entity.phoneNumber != null &&
                                              entity.phoneNumber!.isNotEmpty) {
                                            display +=
                                                ' - ${entity.phoneNumber}';
                                          }
                                          return display.toLowerCase() ==
                                              value.toLowerCase();
                                        });
                                        if (!isValid) {
                                          return 'Please select a valid ${selectedEntityType.value.toString().split('.').last.toLowerCase()} from the list';
                                        }
                                        return null;
                                      },
                                    ),
                        )),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Date Range Picker
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Icon(Iconsax.calendar, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Select Date Range *',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          SizedBox(
                            height: 300,
                            child: SfDateRangePicker(
                              view: DateRangePickerView.month,
                              selectionMode: DateRangePickerSelectionMode.range,
                              initialSelectedRange: PickerDateRange(
                                DateTime.now()
                                    .subtract(const Duration(days: 30)),
                                DateTime.now(),
                              ),
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                if (args.value is PickerDateRange) {
                                  setState(() {
                                    startDate = args.value.startDate;
                                    endDate = args.value.endDate;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (selectedEntity.value == null) {
                                Get.snackbar(
                                  'Validation Error',
                                  'Please select an entity',
                                  backgroundColor: TColors.error,
                                  colorText: TColors.white,
                                );
                                return;
                              }

                              if (startDate == null || endDate == null) {
                                Get.snackbar(
                                  'Validation Error',
                                  'Please select a date range',
                                  backgroundColor: TColors.error,
                                  colorText: TColors.white,
                                );
                                return;
                              }

                              Navigator.of(context).pop();

                              // Call the report generation method
                              await reportController
                                  .showAccountBookReportByEntity(
                                selectedEntity.value!,
                                selectedEntityType.value,
                                startDate!,
                                endDate!,
                              );
                            }
                          },
                          child: const Text('Generate Report'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
