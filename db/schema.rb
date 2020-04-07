# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_07_095346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgres_fdw"

  create_table "Tutors", id: false, comment: "RELATION BETWEEN op_session AND op_faculty", force: :cascade do |t|
    t.integer "op_session_id", null: false
    t.integer "op_faculty_id", null: false
    t.index ["op_faculty_id"], name: "Tutors_op_faculty_id_idx"
    t.index ["op_session_id", "op_faculty_id"], name: "Tutors_op_session_id_op_faculty_id_key", unique: true
    t.index ["op_session_id"], name: "Tutors_op_session_id_idx"
  end

  create_table "account_account", id: :serial, comment: "Account", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "currency_id", comment: "Account Currency"
    t.string "code", limit: 64, null: false, comment: "Code"
    t.boolean "deprecated", comment: "Deprecated"
    t.integer "user_type_id", null: false, comment: "Type"
    t.string "internal_type", comment: "Internal Type"
    t.datetime "last_time_entries_checked", comment: "Latest Invoices & Payments Matching Date"
    t.boolean "reconcile", comment: "Allow Reconciliation"
    t.text "note", comment: "Internal Notes"
    t.integer "company_id", null: false, comment: "Company"
    t.integer "group_id", comment: "Group"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code", "company_id"], name: "account_account_code_company_uniq", unique: true
    t.index ["code"], name: "account_account_code_index"
    t.index ["deprecated"], name: "account_account_deprecated_index"
    t.index ["name"], name: "account_account_name_index"
  end

  create_table "account_account_account_tag", id: false, comment: "RELATION BETWEEN account_account AND account_account_tag", force: :cascade do |t|
    t.integer "account_account_id", null: false
    t.integer "account_account_tag_id", null: false
    t.index ["account_account_id", "account_account_tag_id"], name: "account_account_account_tag_account_account_id_account_acco_key", unique: true
    t.index ["account_account_id"], name: "account_account_account_tag_account_account_id_idx"
    t.index ["account_account_tag_id"], name: "account_account_account_tag_account_account_tag_id_idx"
  end

  create_table "account_account_financial_report", id: false, comment: "RELATION BETWEEN account_financial_report AND account_account", force: :cascade do |t|
    t.integer "report_line_id", null: false
    t.integer "account_id", null: false
    t.index ["account_id"], name: "account_account_financial_report_account_id_idx"
    t.index ["report_line_id", "account_id"], name: "account_account_financial_report_report_line_id_account_id_key", unique: true
    t.index ["report_line_id"], name: "account_account_financial_report_report_line_id_idx"
  end

  create_table "account_account_financial_report_type", id: false, comment: "RELATION BETWEEN account_financial_report AND account_account_type", force: :cascade do |t|
    t.integer "report_id", null: false
    t.integer "account_type_id", null: false
    t.index ["account_type_id"], name: "account_account_financial_report_type_account_type_id_idx"
    t.index ["report_id", "account_type_id"], name: "account_account_financial_report__report_id_account_type_id_key", unique: true
    t.index ["report_id"], name: "account_account_financial_report_type_report_id_idx"
  end

  create_table "account_account_tag", id: :serial, comment: "Account Tag", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "applicability", null: false, comment: "Applicability"
    t.integer "color", comment: "Color Index"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_account_tag_account_tax_template_rel", id: false, comment: "RELATION BETWEEN account_tax_template AND account_account_tag", force: :cascade do |t|
    t.integer "account_tax_template_id", null: false
    t.integer "account_account_tag_id", null: false
    t.index ["account_account_tag_id"], name: "account_account_tag_account_tax_temp_account_account_tag_id_idx"
    t.index ["account_tax_template_id", "account_account_tag_id"], name: "account_account_tag_account_t_account_tax_template_id_accou_key", unique: true
    t.index ["account_tax_template_id"], name: "account_account_tag_account_tax_tem_account_tax_template_id_idx"
  end

  create_table "account_account_tax_default_rel", id: false, comment: "RELATION BETWEEN account_account AND account_tax", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "tax_id", null: false
    t.index ["account_id", "tax_id"], name: "account_account_tax_default_rel_account_id_tax_id_key", unique: true
    t.index ["account_id"], name: "account_account_tax_default_rel_account_id_idx"
    t.index ["tax_id"], name: "account_account_tax_default_rel_tax_id_idx"
  end

  create_table "account_account_template", id: :serial, comment: "Templates for Accounts", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "currency_id", comment: "Account Currency"
    t.string "code", limit: 64, null: false, comment: "Code"
    t.integer "user_type_id", null: false, comment: "Type"
    t.boolean "reconcile", comment: "Allow Invoices & payments Matching"
    t.text "note", comment: "Note"
    t.boolean "nocreate", comment: "Optional Create"
    t.integer "chart_template_id", comment: "Chart Template"
    t.integer "group_id", comment: "Group"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "account_account_template_code_index"
    t.index ["name"], name: "account_account_template_name_index"
  end

  create_table "account_account_template_account_tag", id: false, comment: "RELATION BETWEEN account_account_template AND account_account_tag", force: :cascade do |t|
    t.integer "account_account_template_id", null: false
    t.integer "account_account_tag_id", null: false
    t.index ["account_account_tag_id"], name: "account_account_template_account_tag_account_account_tag_id_idx"
    t.index ["account_account_template_id", "account_account_tag_id"], name: "account_account_template_acco_account_account_template_id_a_key", unique: true
    t.index ["account_account_template_id"], name: "account_account_template_accoun_account_account_template_id_idx"
  end

  create_table "account_account_template_tax_rel", id: false, comment: "RELATION BETWEEN account_account_template AND account_tax_template", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "tax_id", null: false
    t.index ["account_id", "tax_id"], name: "account_account_template_tax_rel_account_id_tax_id_key", unique: true
    t.index ["account_id"], name: "account_account_template_tax_rel_account_id_idx"
    t.index ["tax_id"], name: "account_account_template_tax_rel_tax_id_idx"
  end

  create_table "account_account_type", id: :serial, comment: "Account Type", force: :cascade do |t|
    t.string "name", null: false, comment: "Account Type"
    t.boolean "include_initial_balance", comment: "Bring Accounts Balance Forward"
    t.string "type", null: false, comment: "Type"
    t.text "note", comment: "Description"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_account_type_rel", id: false, comment: "RELATION BETWEEN account_journal AND account_account", force: :cascade do |t|
    t.integer "journal_id", null: false
    t.integer "account_id", null: false
    t.index ["account_id"], name: "account_account_type_rel_account_id_idx"
    t.index ["journal_id", "account_id"], name: "account_account_type_rel_journal_id_account_id_key", unique: true
    t.index ["journal_id"], name: "account_account_type_rel_journal_id_idx"
  end

  create_table "account_aged_trial_balance", id: :serial, comment: "Account Aged Trial balance Report", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.string "result_selection", null: false, comment: "Partner's"
    t.integer "period_length", null: false, comment: "Period Length (days)"
    t.date "date_from", comment: "Start Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_aged_trial_balance_account_journal_rel", id: false, comment: "RELATION BETWEEN account_aged_trial_balance AND account_journal", force: :cascade do |t|
    t.integer "account_aged_trial_balance_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_aged_trial_balance_id", "account_journal_id"], name: "account_aged_trial_balance_ac_account_aged_trial_balance_id_key", unique: true
    t.index ["account_aged_trial_balance_id"], name: "account_aged_trial_balance_ac_account_aged_trial_balance_id_idx"
    t.index ["account_journal_id"], name: "account_aged_trial_balance_account_journ_account_journal_id_idx"
  end

  create_table "account_analytic_account", id: :serial, comment: "Analytic Account", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Analytic Account"
    t.string "code", comment: "Reference"
    t.boolean "active", comment: "Active"
    t.integer "company_id", comment: "Company"
    t.integer "partner_id", comment: "Customer"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "account_analytic_account_code_index"
    t.index ["name"], name: "account_analytic_account_name_index"
  end

  create_table "account_analytic_account_tag_rel", id: false, comment: "RELATION BETWEEN account_analytic_account AND account_analytic_tag", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "tag_id", null: false
    t.index ["account_id", "tag_id"], name: "account_analytic_account_tag_rel_account_id_tag_id_key", unique: true
    t.index ["account_id"], name: "account_analytic_account_tag_rel_account_id_idx"
    t.index ["tag_id"], name: "account_analytic_account_tag_rel_tag_id_idx"
  end

  create_table "account_analytic_line", id: :serial, comment: "Analytic Line", force: :cascade do |t|
    t.string "name", null: false, comment: "Description"
    t.date "date", null: false, comment: "Date"
    t.decimal "amount", null: false, comment: "Amount"
    t.float "unit_amount", comment: "Quantity"
    t.integer "account_id", null: false, comment: "Analytic Account"
    t.integer "partner_id", comment: "Partner"
    t.integer "user_id", comment: "User"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "product_uom_id", comment: "Unit of Measure"
    t.integer "product_id", comment: "Product"
    t.integer "general_account_id", comment: "Financial Account"
    t.integer "move_id", comment: "Move Line"
    t.string "code", limit: 8, comment: "Code"
    t.string "ref", comment: "Ref."
    t.integer "currency_id", comment: "Account Currency"
    t.decimal "amount_currency", comment: "Amount Currency"
    t.integer "so_line", comment: "Sales Order Line"
    t.integer "task_id", comment: "Task"
    t.integer "project_id", comment: "Project"
    t.integer "employee_id", comment: "Employee"
    t.integer "department_id", comment: "Department"
    t.integer "holiday_id", comment: "Leave Request"
    t.string "timesheet_invoice_type", comment: "Billable Type"
    t.integer "timesheet_invoice_id", comment: "Invoice"
    t.decimal "timesheet_revenue", comment: "Revenue"
    t.index ["account_id"], name: "account_analytic_line_account_id_index"
    t.index ["date"], name: "account_analytic_line_date_index"
    t.index ["move_id"], name: "account_analytic_line_move_id_index"
    t.index ["task_id"], name: "account_analytic_line_task_id_index"
  end

  create_table "account_analytic_line_tag_rel", id: false, comment: "RELATION BETWEEN account_analytic_line AND account_analytic_tag", force: :cascade do |t|
    t.integer "line_id", null: false
    t.integer "tag_id", null: false
    t.index ["line_id", "tag_id"], name: "account_analytic_line_tag_rel_line_id_tag_id_key", unique: true
    t.index ["line_id"], name: "account_analytic_line_tag_rel_line_id_idx"
    t.index ["tag_id"], name: "account_analytic_line_tag_rel_tag_id_idx"
  end

  create_table "account_analytic_tag", id: :serial, comment: "Analytic Tags", force: :cascade do |t|
    t.string "name", null: false, comment: "Analytic Tag"
    t.integer "color", comment: "Color Index"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "account_analytic_tag_name_index"
  end

  create_table "account_analytic_tag_account_invoice_line_rel", id: false, comment: "RELATION BETWEEN account_invoice_line AND account_analytic_tag", force: :cascade do |t|
    t.integer "account_invoice_line_id", null: false
    t.integer "account_analytic_tag_id", null: false
    t.index ["account_analytic_tag_id"], name: "account_analytic_tag_account_invoic_account_analytic_tag_id_idx"
    t.index ["account_invoice_line_id", "account_analytic_tag_id"], name: "account_analytic_tag_account__account_invoice_line_id_accou_key", unique: true
    t.index ["account_invoice_line_id"], name: "account_analytic_tag_account_invoic_account_invoice_line_id_idx"
  end

  create_table "account_analytic_tag_account_move_line_rel", id: false, comment: "RELATION BETWEEN account_move_line AND account_analytic_tag", force: :cascade do |t|
    t.integer "account_move_line_id", null: false
    t.integer "account_analytic_tag_id", null: false
    t.index ["account_analytic_tag_id"], name: "account_analytic_tag_account_move_l_account_analytic_tag_id_idx"
    t.index ["account_move_line_id", "account_analytic_tag_id"], name: "account_analytic_tag_account__account_move_line_id_account__key", unique: true
    t.index ["account_move_line_id"], name: "account_analytic_tag_account_move_line_account_move_line_id_idx"
  end

  create_table "account_analytic_tag_sale_order_line_rel", id: false, comment: "RELATION BETWEEN sale_order_line AND account_analytic_tag", force: :cascade do |t|
    t.integer "sale_order_line_id", null: false
    t.integer "account_analytic_tag_id", null: false
    t.index ["account_analytic_tag_id"], name: "account_analytic_tag_sale_order_lin_account_analytic_tag_id_idx"
    t.index ["sale_order_line_id", "account_analytic_tag_id"], name: "account_analytic_tag_sale_ord_sale_order_line_id_account_an_key", unique: true
    t.index ["sale_order_line_id"], name: "account_analytic_tag_sale_order_line_rel_sale_order_line_id_idx"
  end

  create_table "account_asset_asset", id: :serial, comment: "Asset/Revenue Recognition", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Asset Name"
    t.string "code", limit: 32, comment: "Reference"
    t.decimal "value", null: false, comment: "Gross Value"
    t.integer "currency_id", null: false, comment: "Currency"
    t.integer "company_id", null: false, comment: "Company"
    t.text "note", comment: "Note"
    t.integer "category_id", null: false, comment: "Category"
    t.date "date", null: false, comment: "Date"
    t.string "state", null: false, comment: "Status"
    t.boolean "active", comment: "Active"
    t.integer "partner_id", comment: "Partner"
    t.string "method", null: false, comment: "Computation Method"
    t.integer "method_number", comment: "Number of Depreciations"
    t.integer "method_period", null: false, comment: "Number of Months in a Period"
    t.date "method_end", comment: "Ending Date"
    t.float "method_progress_factor", comment: "Degressive Factor"
    t.string "method_time", null: false, comment: "Time Method"
    t.boolean "prorata", comment: "Prorata Temporis"
    t.decimal "salvage_value", comment: "Salvage Value"
    t.integer "invoice_id", comment: "Invoice"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_asset_category", id: :serial, comment: "Asset category", force: :cascade do |t|
    t.boolean "active", comment: "Active"
    t.string "name", null: false, comment: "Asset Type"
    t.integer "account_analytic_id", comment: "Analytic Account"
    t.integer "account_asset_id", null: false, comment: "Asset Account"
    t.integer "account_depreciation_id", null: false, comment: "Depreciation Entries: Asset Account"
    t.integer "account_depreciation_expense_id", null: false, comment: "Depreciation Entries: Expense Account"
    t.integer "journal_id", null: false, comment: "Journal"
    t.integer "company_id", null: false, comment: "Company"
    t.string "method", null: false, comment: "Computation Method"
    t.integer "method_number", comment: "Number of Depreciations"
    t.integer "method_period", null: false, comment: "Period Length"
    t.float "method_progress_factor", comment: "Degressive Factor"
    t.string "method_time", null: false, comment: "Time Method"
    t.date "method_end", comment: "Ending date"
    t.boolean "prorata", comment: "Prorata Temporis"
    t.boolean "open_asset", comment: "Auto-confirm Assets"
    t.boolean "group_entries", comment: "Group Journal Entries"
    t.string "type", null: false, comment: "Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "account_asset_category_name_index"
    t.index ["type"], name: "account_asset_category_type_index"
  end

  create_table "account_asset_depreciation_line", id: :serial, comment: "Asset depreciation line", force: :cascade do |t|
    t.string "name", null: false, comment: "Depreciation Name"
    t.integer "sequence", null: false, comment: "Sequence"
    t.integer "asset_id", null: false, comment: "Asset"
    t.decimal "amount", null: false, comment: "Current Depreciation"
    t.decimal "remaining_value", null: false, comment: "Next Period Depreciation"
    t.float "depreciated_value", null: false, comment: "Cumulative Depreciation"
    t.date "depreciation_date", comment: "Depreciation Date"
    t.integer "move_id", comment: "Depreciation Entry"
    t.boolean "move_check", comment: "Linked"
    t.boolean "move_posted_check", comment: "Posted"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["depreciation_date"], name: "account_asset_depreciation_line_depreciation_date_index"
    t.index ["name"], name: "account_asset_depreciation_line_name_index"
  end

  create_table "account_balance_report", id: :serial, comment: "Trial Balance Report", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.string "display_account", null: false, comment: "Display Accounts"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_balance_report_journal_rel", id: false, comment: "RELATION BETWEEN account_balance_report AND account_journal", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "journal_id", null: false
    t.index ["account_id", "journal_id"], name: "account_balance_report_journal_rel_account_id_journal_id_key", unique: true
    t.index ["account_id"], name: "account_balance_report_journal_rel_account_id_idx"
    t.index ["journal_id"], name: "account_balance_report_journal_rel_journal_id_idx"
  end

  create_table "account_bank_accounts_wizard", id: :serial, comment: "account.bank.accounts.wizard", force: :cascade do |t|
    t.string "acc_name", null: false, comment: "Account Name."
    t.integer "bank_account_id", null: false, comment: "Bank Account"
    t.integer "currency_id", comment: "Account Currency"
    t.string "account_type", comment: "Account Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_bank_statement", id: :serial, comment: "Bank Statement", force: :cascade do |t|
    t.string "name", comment: "Reference"
    t.string "reference", comment: "External Reference"
    t.date "date", null: false, comment: "Date"
    t.datetime "date_done", comment: "Closed On"
    t.decimal "balance_start", comment: "Starting Balance"
    t.decimal "balance_end_real", comment: "Ending Balance"
    t.string "state", null: false, comment: "Status"
    t.integer "journal_id", null: false, comment: "Journal"
    t.integer "company_id", comment: "Company"
    t.decimal "total_entry_encoding", comment: "Transactions Subtotal"
    t.decimal "balance_end", comment: "Computed Balance"
    t.decimal "difference", comment: "Difference"
    t.integer "user_id", comment: "Responsible"
    t.integer "cashbox_start_id", comment: "Starting Cashbox"
    t.integer "cashbox_end_id", comment: "Ending Cashbox"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "pos_session_id", comment: "Session"
    t.index ["date"], name: "account_bank_statement_date_index"
  end

  create_table "account_bank_statement_cashbox", id: :serial, comment: "Account Bank Statement Cashbox Details", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_bank_statement_closebalance", id: :serial, comment: "Account Bank Statement closing balance", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_bank_statement_import", id: :serial, comment: "Import Bank Statement", force: :cascade do |t|
    t.binary "data_file", null: false, comment: "Bank Statement File"
    t.string "filename", comment: "Filename"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_bank_statement_import_journal_creation", id: :serial, comment: "Import Bank Statement Journal Creation Wizard", force: :cascade do |t|
    t.integer "journal_id", null: false, comment: "Journal"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_bank_statement_line", id: :serial, comment: "Bank Statement Line", force: :cascade do |t|
    t.string "name", null: false, comment: "Label"
    t.date "date", null: false, comment: "Date"
    t.decimal "amount", comment: "Amount"
    t.integer "partner_id", comment: "Partner"
    t.integer "bank_account_id", comment: "Bank Account"
    t.integer "account_id", comment: "Counterpart Account"
    t.integer "statement_id", null: false, comment: "Statement"
    t.integer "journal_id", comment: "Journal"
    t.string "partner_name", comment: "Partner Name"
    t.string "ref", comment: "Reference"
    t.text "note", comment: "Notes"
    t.integer "sequence", comment: "Sequence"
    t.integer "company_id", comment: "Company"
    t.decimal "amount_currency", comment: "Amount Currency"
    t.integer "currency_id", comment: "Currency"
    t.string "move_name", comment: "Journal Entry Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "unique_import_id", comment: "Import ID"
    t.integer "pos_statement_id", comment: "POS statement"
    t.index ["sequence"], name: "account_bank_statement_line_sequence_index"
    t.index ["statement_id"], name: "account_bank_statement_line_statement_id_index"
    t.index ["unique_import_id"], name: "account_bank_statement_line_unique_import_id", unique: true
  end

  create_table "account_cash_rounding", id: :serial, comment: "Account Rounding", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.float "rounding", null: false, comment: "Rounding Precision"
    t.string "strategy", null: false, comment: "Rounding Strategy"
    t.integer "account_id", comment: "Account"
    t.string "rounding_method", null: false, comment: "Rounding Method"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_cashbox_line", id: :serial, comment: "CashBox Line", force: :cascade do |t|
    t.decimal "coin_value", null: false, comment: "Coin/Bill Value"
    t.integer "number", comment: "Number of Coins/Bills"
    t.integer "cashbox_id", comment: "Cashbox"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "default_pos_id", comment: "This cashbox line is used by default when opening or closing a balance for this point of sale"
  end

  create_table "account_chart_template", id: :serial, comment: "Templates for Account Chart", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "company_id", comment: "Company"
    t.integer "parent_id", comment: "Parent Chart Template"
    t.integer "code_digits", null: false, comment: "# of Digits"
    t.boolean "visible", comment: "Can be Visible?"
    t.integer "currency_id", null: false, comment: "Currency"
    t.boolean "use_anglo_saxon", comment: "Use Anglo-Saxon accounting"
    t.boolean "complete_tax_set", comment: "Complete Set of Taxes"
    t.string "bank_account_code_prefix", comment: "Prefix of the bank accounts"
    t.string "cash_account_code_prefix", comment: "Prefix of the main cash accounts"
    t.integer "transfer_account_id", null: false, comment: "Transfer Account"
    t.integer "income_currency_exchange_account_id", comment: "Gain Exchange Rate Account"
    t.integer "expense_currency_exchange_account_id", comment: "Loss Exchange Rate Account"
    t.integer "property_account_receivable_id", comment: "Receivable Account"
    t.integer "property_account_payable_id", comment: "Payable Account"
    t.integer "property_account_expense_categ_id", comment: "Category of Expense Account"
    t.integer "property_account_income_categ_id", comment: "Category of Income Account"
    t.integer "property_account_expense_id", comment: "Expense Account on Product Template"
    t.integer "property_account_income_id", comment: "Income Account on Product Template"
    t.integer "property_stock_account_input_categ_id", comment: "Input Account for Stock Valuation"
    t.integer "property_stock_account_output_categ_id", comment: "Output Account for Stock Valuation"
    t.integer "property_stock_valuation_account_id", comment: "Account Template for Stock Valuation"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_common_account_report", id: :serial, comment: "Account Common Account Report", force: :cascade do |t|
    t.string "display_account", null: false, comment: "Display Accounts"
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_common_account_report_account_journal_rel", id: false, comment: "RELATION BETWEEN account_common_account_report AND account_journal", force: :cascade do |t|
    t.integer "account_common_account_report_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_common_account_report_id", "account_journal_id"], name: "account_common_account_report_account_common_account_report_key", unique: true
    t.index ["account_common_account_report_id"], name: "account_common_account_report_account_common_account_report_idx"
    t.index ["account_journal_id"], name: "account_common_account_report_account_jo_account_journal_id_idx"
  end

  create_table "account_common_journal_report", id: :serial, comment: "Account Common Journal Report", force: :cascade do |t|
    t.boolean "amount_currency", comment: "With Currency"
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_common_journal_report_account_journal_rel", id: false, comment: "RELATION BETWEEN account_common_journal_report AND account_journal", force: :cascade do |t|
    t.integer "account_common_journal_report_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_common_journal_report_id", "account_journal_id"], name: "account_common_journal_report_account_common_journal_report_key", unique: true
    t.index ["account_common_journal_report_id"], name: "account_common_journal_report_account_common_journal_report_idx"
    t.index ["account_journal_id"], name: "account_common_journal_report_account_jo_account_journal_id_idx"
  end

  create_table "account_common_partner_report", id: :serial, comment: "Account Common Partner Report", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.string "result_selection", null: false, comment: "Partner's"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_common_partner_report_account_journal_rel", id: false, comment: "RELATION BETWEEN account_common_partner_report AND account_journal", force: :cascade do |t|
    t.integer "account_common_partner_report_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_common_partner_report_id", "account_journal_id"], name: "account_common_partner_report_account_common_partner_report_key", unique: true
    t.index ["account_common_partner_report_id"], name: "account_common_partner_report_account_common_partner_report_idx"
    t.index ["account_journal_id"], name: "account_common_partner_report_account_jo_account_journal_id_idx"
  end

  create_table "account_common_report", id: :serial, comment: "Account Common Report", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_common_report_account_journal_rel", id: false, comment: "RELATION BETWEEN account_common_report AND account_journal", force: :cascade do |t|
    t.integer "account_common_report_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_common_report_id", "account_journal_id"], name: "account_common_report_account_account_common_report_id_acco_key", unique: true
    t.index ["account_common_report_id"], name: "account_common_report_account_jour_account_common_report_id_idx"
    t.index ["account_journal_id"], name: "account_common_report_account_journal_re_account_journal_id_idx"
  end

  create_table "account_financial_report", id: :serial, comment: "Account Report", force: :cascade do |t|
    t.string "name", null: false, comment: "Report Name"
    t.integer "parent_id", comment: "Parent"
    t.integer "sequence", comment: "Sequence"
    t.integer "level", comment: "Level"
    t.string "type", comment: "Type"
    t.integer "account_report_id", comment: "Report Value"
    t.integer "sign", null: false, comment: "Sign on Reports"
    t.string "display_detail", comment: "Display details"
    t.integer "style_overwrite", comment: "Financial Report Style"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_financial_year_op", id: :serial, comment: "account.financial.year.op", force: :cascade do |t|
    t.integer "company_id", null: false, comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_fiscal_position", id: :serial, comment: "Fiscal Position", force: :cascade do |t|
    t.integer "sequence", comment: "Sequence"
    t.string "name", null: false, comment: "Fiscal Position"
    t.boolean "active", comment: "Active"
    t.integer "company_id", comment: "Company"
    t.text "note", comment: "Notes"
    t.boolean "auto_apply", comment: "Detect Automatically"
    t.boolean "vat_required", comment: "VAT required"
    t.integer "country_id", comment: "Country"
    t.integer "country_group_id", comment: "Country Group"
    t.integer "zip_from", comment: "Zip Range From"
    t.integer "zip_to", comment: "Zip Range To"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_fiscal_position_account", id: :serial, comment: "Accounts Fiscal Position", force: :cascade do |t|
    t.integer "position_id", null: false, comment: "Fiscal Position"
    t.integer "account_src_id", null: false, comment: "Account on Product"
    t.integer "account_dest_id", null: false, comment: "Account to Use Instead"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["position_id", "account_src_id", "account_dest_id"], name: "account_fiscal_position_account_account_src_dest_uniq", unique: true
  end

  create_table "account_fiscal_position_account_template", id: :serial, comment: "Template Account Fiscal Mapping", force: :cascade do |t|
    t.integer "position_id", null: false, comment: "Fiscal Mapping"
    t.integer "account_src_id", null: false, comment: "Account Source"
    t.integer "account_dest_id", null: false, comment: "Account Destination"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_fiscal_position_pos_config_rel", id: false, comment: "RELATION BETWEEN pos_config AND account_fiscal_position", force: :cascade do |t|
    t.integer "pos_config_id", null: false
    t.integer "account_fiscal_position_id", null: false
    t.index ["account_fiscal_position_id"], name: "account_fiscal_position_pos_conf_account_fiscal_position_id_idx"
    t.index ["pos_config_id", "account_fiscal_position_id"], name: "account_fiscal_position_pos_c_pos_config_id_account_fiscal__key", unique: true
    t.index ["pos_config_id"], name: "account_fiscal_position_pos_config_rel_pos_config_id_idx"
  end

  create_table "account_fiscal_position_res_country_state_rel", id: false, comment: "RELATION BETWEEN account_fiscal_position AND res_country_state", force: :cascade do |t|
    t.integer "account_fiscal_position_id", null: false
    t.integer "res_country_state_id", null: false
    t.index ["account_fiscal_position_id", "res_country_state_id"], name: "account_fiscal_position_res_c_account_fiscal_position_id_re_key", unique: true
    t.index ["account_fiscal_position_id"], name: "account_fiscal_position_res_coun_account_fiscal_position_id_idx"
    t.index ["res_country_state_id"], name: "account_fiscal_position_res_country_st_res_country_state_id_idx"
  end

  create_table "account_fiscal_position_tax", id: :serial, comment: "Taxes Fiscal Position", force: :cascade do |t|
    t.integer "position_id", null: false, comment: "Fiscal Position"
    t.integer "tax_src_id", null: false, comment: "Tax on Product"
    t.integer "tax_dest_id", comment: "Tax to Apply"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["position_id", "tax_src_id", "tax_dest_id"], name: "account_fiscal_position_tax_tax_src_dest_uniq", unique: true
  end

  create_table "account_fiscal_position_tax_template", id: :serial, comment: "Template Tax Fiscal Position", force: :cascade do |t|
    t.integer "position_id", null: false, comment: "Fiscal Position"
    t.integer "tax_src_id", null: false, comment: "Tax Source"
    t.integer "tax_dest_id", comment: "Replacement Tax"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_fiscal_position_template", id: :serial, comment: "Template for Fiscal Position", force: :cascade do |t|
    t.integer "sequence", comment: "Sequence"
    t.string "name", null: false, comment: "Fiscal Position Template"
    t.integer "chart_template_id", null: false, comment: "Chart Template"
    t.text "note", comment: "Notes"
    t.boolean "auto_apply", comment: "Detect Automatically"
    t.boolean "vat_required", comment: "VAT required"
    t.integer "country_id", comment: "Country"
    t.integer "country_group_id", comment: "Country Group"
    t.integer "zip_from", comment: "Zip Range From"
    t.integer "zip_to", comment: "Zip Range To"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_fiscal_position_template_res_country_state_rel", id: false, comment: "RELATION BETWEEN account_fiscal_position_template AND res_country_state", force: :cascade do |t|
    t.integer "account_fiscal_position_template_id", null: false
    t.integer "res_country_state_id", null: false
    t.index ["account_fiscal_position_template_id", "res_country_state_id"], name: "account_fiscal_position_templ_account_fiscal_position_templ_key", unique: true
    t.index ["account_fiscal_position_template_id"], name: "account_fiscal_position_templ_account_fiscal_position_templ_idx"
    t.index ["res_country_state_id"], name: "account_fiscal_position_template_res_c_res_country_state_id_idx"
  end

  create_table "account_full_reconcile", id: :serial, comment: "Full Reconcile", force: :cascade do |t|
    t.string "name", null: false, comment: "Number"
    t.integer "exchange_move_id", comment: "Exchange Move"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_group", id: :serial, comment: "account.group", force: :cascade do |t|
    t.integer "parent_left"
    t.integer "parent_right"
    t.integer "parent_id", comment: "Parent"
    t.string "name", null: false, comment: "Name"
    t.string "code_prefix", comment: "Code Prefix"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["parent_id"], name: "account_group_parent_id_index"
    t.index ["parent_left"], name: "account_group_parent_left_index"
    t.index ["parent_right"], name: "account_group_parent_right_index"
  end

  create_table "account_invoice", id: :serial, comment: "Invoice", force: :cascade do |t|
    t.string "name", comment: "Reference/Description"
    t.string "origin", comment: "Source Document"
    t.string "type", comment: "Type"
    t.string "access_token", comment: "Security Token"
    t.integer "refund_invoice_id", comment: "Invoice for which this invoice is the credit note"
    t.string "number", comment: "Number"
    t.string "move_name", comment: "Journal Entry Name"
    t.string "reference", comment: "Vendor Reference"
    t.string "reference_type", null: false, comment: "Payment Reference"
    t.text "comment", comment: "Additional Information"
    t.string "state", comment: "Status"
    t.boolean "sent", comment: "Sent"
    t.date "date_invoice", comment: "Invoice Date"
    t.date "date_due", comment: "Due Date"
    t.integer "partner_id", null: false, comment: "Partner"
    t.integer "payment_term_id", comment: "Payment Terms"
    t.date "date", comment: "Accounting Date"
    t.integer "account_id", null: false, comment: "Account"
    t.integer "move_id", comment: "Journal Entry"
    t.decimal "amount_untaxed", comment: "Untaxed Amount"
    t.decimal "amount_untaxed_signed", comment: "Untaxed Amount in Company Currency"
    t.decimal "amount_tax", comment: "Tax"
    t.decimal "amount_total", comment: "Total"
    t.decimal "amount_total_signed", comment: "Total in Invoice Currency"
    t.decimal "amount_total_company_signed", comment: "Total in Company Currency"
    t.integer "currency_id", null: false, comment: "Currency"
    t.integer "journal_id", null: false, comment: "Journal"
    t.integer "company_id", null: false, comment: "Company"
    t.boolean "reconciled", comment: "Paid/Reconciled"
    t.integer "partner_bank_id", comment: "Bank Account"
    t.decimal "residual", comment: "Amount Due"
    t.decimal "residual_signed", comment: "Amount Due in Invoice Currency"
    t.decimal "residual_company_signed", comment: "Amount Due in Company Currency"
    t.integer "user_id", comment: "Salesperson"
    t.integer "fiscal_position_id", comment: "Fiscal Position"
    t.integer "commercial_partner_id", comment: "Commercial Entity"
    t.integer "cash_rounding_id", comment: "Cash Rounding Method"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "team_id", comment: "Sales Channel"
    t.integer "partner_shipping_id", comment: "Delivery Address"
    t.integer "campaign_id", comment: "Campaign"
    t.integer "source_id", comment: "Source"
    t.integer "medium_id", comment: "Medium"
    t.integer "payment_tx_id", comment: "Last Transaction"
    t.integer "payment_acquirer_id", comment: "Payment Acquirer"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.index ["date_due"], name: "account_invoice_date_due_index"
    t.index ["date_invoice"], name: "account_invoice_date_invoice_index"
    t.index ["move_id"], name: "account_invoice_move_id_index"
    t.index ["name"], name: "account_invoice_name_index"
    t.index ["number", "company_id", "journal_id", "type"], name: "account_invoice_number_uniq", unique: true
    t.index ["state"], name: "account_invoice_state_index"
    t.index ["type"], name: "account_invoice_type_index"
  end

  create_table "account_invoice_account_move_line_rel", id: false, comment: "RELATION BETWEEN account_invoice AND account_move_line", force: :cascade do |t|
    t.integer "account_invoice_id", null: false
    t.integer "account_move_line_id", null: false
    t.index ["account_invoice_id", "account_move_line_id"], name: "account_invoice_account_move__account_invoice_id_account_mo_key", unique: true
    t.index ["account_invoice_id"], name: "account_invoice_account_move_line_rel_account_invoice_id_idx"
    t.index ["account_move_line_id"], name: "account_invoice_account_move_line_rel_account_move_line_id_idx"
  end

  create_table "account_invoice_account_register_payments_rel", id: false, comment: "RELATION BETWEEN account_register_payments AND account_invoice", force: :cascade do |t|
    t.integer "account_register_payments_id", null: false
    t.integer "account_invoice_id", null: false
    t.index ["account_invoice_id"], name: "account_invoice_account_register_payment_account_invoice_id_idx"
    t.index ["account_register_payments_id", "account_invoice_id"], name: "account_invoice_account_regis_account_register_payments_id__key", unique: true
    t.index ["account_register_payments_id"], name: "account_invoice_account_regist_account_register_payments_id_idx"
  end

  create_table "account_invoice_confirm", id: :serial, comment: "Confirm the selected invoices", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_invoice_line", id: :serial, comment: "Invoice Line", force: :cascade do |t|
    t.text "name", null: false, comment: "Description"
    t.string "origin", comment: "Source Document"
    t.integer "sequence", comment: "Sequence"
    t.integer "invoice_id", comment: "Invoice Reference"
    t.integer "uom_id", comment: "Unit of Measure"
    t.integer "product_id", comment: "Product"
    t.integer "account_id", null: false, comment: "Account"
    t.decimal "price_unit", null: false, comment: "Unit Price"
    t.decimal "price_subtotal", comment: "Amount"
    t.decimal "price_total", comment: "Amount"
    t.decimal "price_subtotal_signed", comment: "Amount Signed"
    t.decimal "quantity", null: false, comment: "Quantity"
    t.decimal "discount", comment: "Discount (%)"
    t.integer "account_analytic_id", comment: "Analytic Account"
    t.integer "company_id", comment: "Company"
    t.integer "partner_id", comment: "Partner"
    t.integer "currency_id", comment: "Currency"
    t.boolean "is_rounding_line", comment: "Rounding Line"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "layout_category_id", comment: "Section"
    t.integer "layout_category_sequence", comment: "Layout Sequence"
    t.integer "asset_category_id", comment: "Asset Category"
    t.date "asset_start_date", comment: "Asset Start Date"
    t.date "asset_end_date", comment: "Asset End Date"
    t.decimal "asset_mrr", comment: "Monthly Recurring Revenue"
    t.index ["invoice_id"], name: "account_invoice_line_invoice_id_index"
    t.index ["product_id"], name: "account_invoice_line_product_id_index"
    t.index ["uom_id"], name: "account_invoice_line_uom_id_index"
  end

  create_table "account_invoice_line_tax", id: false, comment: "RELATION BETWEEN account_invoice_line AND account_tax", force: :cascade do |t|
    t.integer "invoice_line_id", null: false
    t.integer "tax_id", null: false
    t.index ["invoice_line_id", "tax_id"], name: "account_invoice_line_tax_invoice_line_id_tax_id_key", unique: true
    t.index ["invoice_line_id"], name: "account_invoice_line_tax_invoice_line_id_idx"
    t.index ["tax_id"], name: "account_invoice_line_tax_tax_id_idx"
  end

  create_table "account_invoice_payment_rel", id: false, comment: "RELATION BETWEEN account_payment AND account_invoice", force: :cascade do |t|
    t.integer "payment_id", null: false
    t.integer "invoice_id", null: false
    t.index ["invoice_id"], name: "account_invoice_payment_rel_invoice_id_idx"
    t.index ["payment_id", "invoice_id"], name: "account_invoice_payment_rel_payment_id_invoice_id_key", unique: true
    t.index ["payment_id"], name: "account_invoice_payment_rel_payment_id_idx"
  end

  create_table "account_invoice_refund", id: :serial, comment: "Credit Note", force: :cascade do |t|
    t.date "date_invoice", null: false, comment: "Credit Note Date"
    t.date "date", comment: "Accounting Date"
    t.string "description", null: false, comment: "Reason"
    t.string "filter_refund", null: false, comment: "Refund Method"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_invoice_tax", id: :serial, comment: "Invoice Tax", force: :cascade do |t|
    t.integer "invoice_id", comment: "Invoice"
    t.string "name", null: false, comment: "Tax Description"
    t.integer "tax_id", comment: "Tax"
    t.integer "account_id", null: false, comment: "Tax Account"
    t.integer "account_analytic_id", comment: "Analytic account"
    t.decimal "amount", comment: "Amount"
    t.decimal "amount_rounding", comment: "Amount Rounding"
    t.boolean "manual", comment: "Manual"
    t.integer "sequence", comment: "Sequence"
    t.integer "company_id", comment: "Company"
    t.integer "currency_id", comment: "Currency"
    t.decimal "base", comment: "Base"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["invoice_id"], name: "account_invoice_tax_invoice_id_index"
  end

  create_table "account_journal", id: :serial, comment: "Journal", force: :cascade do |t|
    t.string "name", null: false, comment: "Journal Name"
    t.string "code", limit: 5, null: false, comment: "Short Code"
    t.boolean "active", comment: "Active"
    t.string "type", null: false, comment: "Type"
    t.integer "default_credit_account_id", comment: "Default Credit Account"
    t.integer "default_debit_account_id", comment: "Default Debit Account"
    t.boolean "update_posted", comment: "Allow Cancelling Entries"
    t.boolean "group_invoice_lines", comment: "Group Invoice Lines"
    t.integer "sequence_id", null: false, comment: "Entry Sequence"
    t.integer "refund_sequence_id", comment: "Credit Note Entry Sequence"
    t.integer "sequence", comment: "Sequence"
    t.integer "currency_id", comment: "Currency"
    t.integer "company_id", null: false, comment: "Company"
    t.boolean "refund_sequence", comment: "Dedicated Credit Note Sequence"
    t.boolean "at_least_one_inbound", comment: "At Least One Inbound"
    t.boolean "at_least_one_outbound", comment: "At Least One Outbound"
    t.integer "profit_account_id", comment: "Profit Account"
    t.integer "loss_account_id", comment: "Loss Account"
    t.integer "bank_account_id", comment: "Bank Account"
    t.string "bank_statements_source", comment: "Bank Feeds"
    t.boolean "show_on_dashboard", comment: "Show journal on dashboard"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "journal_user", comment: "Use in Point of Sale"
    t.float "amount_authorized_diff", comment: "Amount Authorized Difference"
    t.index ["code", "name", "company_id"], name: "account_journal_code_company_uniq", unique: true
    t.index ["company_id"], name: "account_journal_company_id_index"
  end

  create_table "account_journal_account_print_journal_rel", id: false, comment: "RELATION BETWEEN account_print_journal AND account_journal", force: :cascade do |t|
    t.integer "account_print_journal_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_journal_id"], name: "account_journal_account_print_journal_re_account_journal_id_idx"
    t.index ["account_print_journal_id", "account_journal_id"], name: "account_journal_account_print_account_print_journal_id_acco_key", unique: true
    t.index ["account_print_journal_id"], name: "account_journal_account_print_jour_account_print_journal_id_idx"
  end

  create_table "account_journal_account_report_partner_ledger_rel", id: false, comment: "RELATION BETWEEN account_report_partner_ledger AND account_journal", force: :cascade do |t|
    t.integer "account_report_partner_ledger_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_journal_id"], name: "account_journal_account_report_partner_l_account_journal_id_idx"
    t.index ["account_report_partner_ledger_id", "account_journal_id"], name: "account_journal_account_repor_account_report_partner_ledger_key", unique: true
    t.index ["account_report_partner_ledger_id"], name: "account_journal_account_repor_account_report_partner_ledger_idx"
  end

  create_table "account_journal_account_tax_report_rel", id: false, comment: "RELATION BETWEEN account_tax_report AND account_journal", force: :cascade do |t|
    t.integer "account_tax_report_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_journal_id"], name: "account_journal_account_tax_report_rel_account_journal_id_idx"
    t.index ["account_tax_report_id", "account_journal_id"], name: "account_journal_account_tax_r_account_tax_report_id_account_key", unique: true
    t.index ["account_tax_report_id"], name: "account_journal_account_tax_report_re_account_tax_report_id_idx"
  end

  create_table "account_journal_accounting_report_rel", id: false, comment: "RELATION BETWEEN accounting_report AND account_journal", force: :cascade do |t|
    t.integer "accounting_report_id", null: false
    t.integer "account_journal_id", null: false
    t.index ["account_journal_id"], name: "account_journal_accounting_report_rel_account_journal_id_idx"
    t.index ["accounting_report_id", "account_journal_id"], name: "account_journal_accounting_re_accounting_report_id_account__key", unique: true
    t.index ["accounting_report_id"], name: "account_journal_accounting_report_rel_accounting_report_id_idx"
  end

  create_table "account_journal_inbound_payment_method_rel", id: false, comment: "RELATION BETWEEN account_journal AND account_payment_method", force: :cascade do |t|
    t.integer "journal_id", null: false
    t.integer "inbound_payment_method", null: false
    t.index ["inbound_payment_method"], name: "account_journal_inbound_payment_meth_inbound_payment_method_idx"
    t.index ["journal_id", "inbound_payment_method"], name: "account_journal_inbound_payme_journal_id_inbound_payment_me_key", unique: true
    t.index ["journal_id"], name: "account_journal_inbound_payment_method_rel_journal_id_idx"
  end

  create_table "account_journal_outbound_payment_method_rel", id: false, comment: "RELATION BETWEEN account_journal AND account_payment_method", force: :cascade do |t|
    t.integer "journal_id", null: false
    t.integer "outbound_payment_method", null: false
    t.index ["journal_id", "outbound_payment_method"], name: "account_journal_outbound_paym_journal_id_outbound_payment_m_key", unique: true
    t.index ["journal_id"], name: "account_journal_outbound_payment_method_rel_journal_id_idx"
    t.index ["outbound_payment_method"], name: "account_journal_outbound_payment_me_outbound_payment_method_idx"
  end

  create_table "account_journal_type_rel", id: false, comment: "RELATION BETWEEN account_journal AND account_account_type", force: :cascade do |t|
    t.integer "journal_id", null: false
    t.integer "type_id", null: false
    t.index ["journal_id", "type_id"], name: "account_journal_type_rel_journal_id_type_id_key", unique: true
    t.index ["journal_id"], name: "account_journal_type_rel_journal_id_idx"
    t.index ["type_id"], name: "account_journal_type_rel_type_id_idx"
  end

  create_table "account_move", id: :serial, comment: "Account Entry", force: :cascade do |t|
    t.string "name", null: false, comment: "Number"
    t.string "ref", comment: "Reference"
    t.date "date", null: false, comment: "Date"
    t.integer "journal_id", null: false, comment: "Journal"
    t.integer "currency_id", comment: "Currency"
    t.string "state", null: false, comment: "Status"
    t.integer "partner_id", comment: "Partner"
    t.decimal "amount", comment: "Amount"
    t.text "narration", comment: "Internal Note"
    t.integer "company_id", comment: "Company"
    t.decimal "matched_percentage", comment: "Percentage Matched"
    t.integer "tax_cash_basis_rec_id", comment: "Tax Cash Basis Entry of"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["date"], name: "account_move_date_index"
  end

  create_table "account_move_line", id: :serial, comment: "Journal Item", force: :cascade do |t|
    t.string "name", comment: "Label"
    t.decimal "quantity", comment: "Quantity"
    t.integer "product_uom_id", comment: "Unit of Measure"
    t.integer "product_id", comment: "Product"
    t.decimal "debit", comment: "Debit"
    t.decimal "credit", comment: "Credit"
    t.decimal "balance", comment: "Balance"
    t.decimal "debit_cash_basis", comment: "Debit Cash Basis"
    t.decimal "credit_cash_basis", comment: "Credit Cash Basis"
    t.decimal "balance_cash_basis", comment: "Balance Cash Basis"
    t.decimal "amount_currency", comment: "Amount Currency"
    t.integer "company_currency_id", comment: "Company Currency"
    t.integer "currency_id", comment: "Currency"
    t.decimal "amount_residual", comment: "Residual Amount"
    t.decimal "amount_residual_currency", comment: "Residual Amount in Currency"
    t.decimal "tax_base_amount", comment: "Base Amount"
    t.integer "account_id", null: false, comment: "Account"
    t.integer "move_id", null: false, comment: "Journal Entry"
    t.string "ref", comment: "Reference"
    t.integer "payment_id", comment: "Originator Payment"
    t.integer "statement_line_id", comment: "Bank statement line reconciled with this entry"
    t.integer "statement_id", comment: "Statement"
    t.boolean "reconciled", comment: "Reconciled"
    t.integer "full_reconcile_id", comment: "Matching Number"
    t.integer "journal_id", comment: "Journal"
    t.boolean "blocked", comment: "No Follow-up"
    t.date "date_maturity", null: false, comment: "Due date"
    t.date "date", comment: "Date"
    t.integer "tax_line_id", comment: "Originator tax"
    t.integer "analytic_account_id", comment: "Analytic Account"
    t.integer "company_id", comment: "Company"
    t.integer "invoice_id", comment: "Invoice"
    t.integer "partner_id", comment: "Partner"
    t.integer "user_type_id", comment: "Type"
    t.boolean "tax_exigible", comment: "Appears in VAT report"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "expense_id", comment: "Expense"
    t.index ["account_id"], name: "account_move_line_account_id_index"
    t.index ["date"], name: "account_move_line_date_index"
    t.index ["date_maturity"], name: "account_move_line_date_maturity_index"
    t.index ["journal_id"], name: "account_move_line_journal_id_index"
    t.index ["move_id"], name: "account_move_line_move_id_index"
    t.index ["partner_id", "ref"], name: "account_move_line_partner_id_ref_idx"
    t.index ["ref"], name: "account_move_line_ref_index"
    t.index ["statement_id"], name: "account_move_line_statement_id_index"
    t.index ["statement_line_id"], name: "account_move_line_statement_line_id_index"
    t.index ["user_type_id"], name: "account_move_line_user_type_id_index"
  end

  create_table "account_move_line_account_tax_rel", id: false, comment: "RELATION BETWEEN account_move_line AND account_tax", force: :cascade do |t|
    t.integer "account_move_line_id", null: false
    t.integer "account_tax_id", null: false
    t.index ["account_move_line_id", "account_tax_id"], name: "account_move_line_account_tax_account_move_line_id_account__key", unique: true
    t.index ["account_move_line_id"], name: "account_move_line_account_tax_rel_account_move_line_id_idx"
    t.index ["account_tax_id"], name: "account_move_line_account_tax_rel_account_tax_id_idx"
  end

  create_table "account_move_line_reconcile", id: :serial, comment: "Account move line reconcile", force: :cascade do |t|
    t.integer "trans_nbr", comment: "# of Transaction"
    t.decimal "credit", comment: "Credit amount"
    t.decimal "debit", comment: "Debit amount"
    t.decimal "writeoff", comment: "Write-Off amount"
    t.integer "company_id", null: false, comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_move_line_reconcile_writeoff", id: :serial, comment: "Account move line reconcile (writeoff)", force: :cascade do |t|
    t.integer "journal_id", null: false, comment: "Write-Off Journal"
    t.integer "writeoff_acc_id", null: false, comment: "Write-Off account"
    t.date "date_p", comment: "Date"
    t.string "comment", null: false, comment: "Comment"
    t.integer "analytic_id", comment: "Analytic Account"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_move_reversal", id: :serial, comment: "Account move reversal", force: :cascade do |t|
    t.date "date", null: false, comment: "Reversal date"
    t.integer "journal_id", comment: "Use Specific Journal"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_opening", id: :serial, comment: "account.opening", force: :cascade do |t|
    t.integer "company_id", null: false, comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_partial_reconcile", id: :serial, comment: "Partial Reconcile", force: :cascade do |t|
    t.integer "debit_move_id", null: false, comment: "Debit Move"
    t.integer "credit_move_id", null: false, comment: "Credit Move"
    t.decimal "amount", comment: "Amount"
    t.decimal "amount_currency", comment: "Amount in Currency"
    t.integer "currency_id", comment: "Currency"
    t.integer "company_id", comment: "Currency"
    t.integer "full_reconcile_id", comment: "Full Reconcile"
    t.date "max_date", comment: "Max Date of Matched Lines"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["credit_move_id"], name: "account_partial_reconcile_credit_move_id_index"
    t.index ["debit_move_id"], name: "account_partial_reconcile_debit_move_id_index"
  end

  create_table "account_payment", id: :serial, comment: "Payments", force: :cascade do |t|
    t.integer "payment_method_id", null: false, comment: "Payment Method Type"
    t.string "partner_type", comment: "Partner Type"
    t.integer "partner_id", comment: "Partner"
    t.decimal "amount", null: false, comment: "Payment Amount"
    t.integer "currency_id", null: false, comment: "Currency"
    t.date "payment_date", null: false, comment: "Payment Date"
    t.string "communication", comment: "Memo"
    t.integer "journal_id", null: false, comment: "Payment Journal"
    t.integer "company_id", comment: "Company"
    t.string "name", comment: "Name"
    t.string "state", comment: "Status"
    t.string "payment_type", null: false, comment: "Payment Type"
    t.string "payment_reference", comment: "Payment Reference"
    t.string "move_name", comment: "Journal Entry Name"
    t.integer "destination_journal_id", comment: "Transfer To"
    t.string "payment_difference_handling", comment: "Payment Difference"
    t.integer "writeoff_account_id", comment: "Difference Account"
    t.string "writeoff_label", comment: "Journal Item Label"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "payment_transaction_id", comment: "Payment Transaction"
    t.integer "payment_token_id", comment: "Saved payment token"
    t.date "date_due", comment: "Due date"
    t.text "note", comment: "Ghi chú"
  end

  create_table "account_payment_method", id: :serial, comment: "Payment Methods", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.string "payment_type", null: false, comment: "Payment Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_payment_term", id: :serial, comment: "Payment Terms", force: :cascade do |t|
    t.string "name", null: false, comment: "Payment Terms"
    t.boolean "active", comment: "Active"
    t.text "note", comment: "Description on the Invoice"
    t.integer "company_id", null: false, comment: "Company"
    t.integer "sequence", null: false, comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_payment_term_line", id: :serial, comment: "Payment Terms Line", force: :cascade do |t|
    t.string "value", null: false, comment: "Type"
    t.decimal "value_amount", comment: "Value"
    t.integer "days", null: false, comment: "Number of Days"
    t.string "option", null: false, comment: "Options"
    t.integer "payment_id", null: false, comment: "Payment Terms"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["payment_id"], name: "account_payment_term_line_payment_id_index"
  end

  create_table "account_print_journal", id: :serial, comment: "Account Print Journal", force: :cascade do |t|
    t.string "sort_selection", null: false, comment: "Entries Sorted by"
    t.boolean "amount_currency", comment: "With Currency"
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_reconcile_model", id: :serial, comment: "Preset to create journal entries during a invoices and payments matching", force: :cascade do |t|
    t.string "name", null: false, comment: "Button Label"
    t.integer "sequence", null: false, comment: "Sequence"
    t.boolean "has_second_line", comment: "Add a second line"
    t.integer "company_id", null: false, comment: "Company"
    t.integer "account_id", comment: "Account"
    t.integer "journal_id", comment: "Journal"
    t.string "label", comment: "Journal Item Label"
    t.string "amount_type", null: false, comment: "Amount Type"
    t.decimal "amount", null: false, comment: "Amount"
    t.integer "tax_id", comment: "Tax"
    t.integer "analytic_account_id", comment: "Analytic Account"
    t.integer "second_account_id", comment: "Second Account"
    t.integer "second_journal_id", comment: "Second Journal"
    t.string "second_label", comment: "Second Journal Item Label"
    t.string "second_amount_type", null: false, comment: "Second Amount type"
    t.decimal "second_amount", null: false, comment: "Second Amount"
    t.integer "second_tax_id", comment: "Second Tax"
    t.integer "second_analytic_account_id", comment: "Second Analytic Account"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_reconcile_model_template", id: :serial, comment: "account.reconcile.model.template", force: :cascade do |t|
    t.integer "chart_template_id", null: false, comment: "Chart Template"
    t.string "name", null: false, comment: "Button Label"
    t.integer "sequence", null: false, comment: "Sequence"
    t.boolean "has_second_line", comment: "Add a second line"
    t.integer "account_id", comment: "Account"
    t.string "label", comment: "Journal Item Label"
    t.string "amount_type", null: false, comment: "Amount Type"
    t.decimal "amount", null: false, comment: "Amount"
    t.integer "tax_id", comment: "Tax"
    t.integer "second_account_id", comment: "Second Account"
    t.string "second_label", comment: "Second Journal Item Label"
    t.string "second_amount_type", null: false, comment: "Second Amount type"
    t.decimal "second_amount", null: false, comment: "Second Amount"
    t.integer "second_tax_id", comment: "Second Tax"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_register_payments", id: :serial, comment: "Register payments on multiple invoices", force: :cascade do |t|
    t.boolean "multi", comment: "Multi"
    t.string "payment_type", null: false, comment: "Payment Type"
    t.integer "payment_method_id", null: false, comment: "Payment Method Type"
    t.string "partner_type", comment: "Partner Type"
    t.integer "partner_id", comment: "Partner"
    t.decimal "amount", null: false, comment: "Payment Amount"
    t.integer "currency_id", null: false, comment: "Currency"
    t.date "payment_date", null: false, comment: "Payment Date"
    t.string "communication", comment: "Memo"
    t.integer "journal_id", null: false, comment: "Payment Journal"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_report_general_ledger", id: :serial, comment: "General Ledger Report", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.string "display_account", null: false, comment: "Display Accounts"
    t.boolean "initial_balance", comment: "Include Initial Balances"
    t.string "sortby", null: false, comment: "Sort by"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_report_general_ledger_journal_rel", id: false, comment: "RELATION BETWEEN account_report_general_ledger AND account_journal", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "journal_id", null: false
    t.index ["account_id", "journal_id"], name: "account_report_general_ledger_journal_account_id_journal_id_key", unique: true
    t.index ["account_id"], name: "account_report_general_ledger_journal_rel_account_id_idx"
    t.index ["journal_id"], name: "account_report_general_ledger_journal_rel_journal_id_idx"
  end

  create_table "account_report_partner_ledger", id: :serial, comment: "Account Partner Ledger", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.string "result_selection", null: false, comment: "Partner's"
    t.boolean "amount_currency", comment: "With Currency"
    t.boolean "reconciled", comment: "Reconciled Entries"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_tax", id: :serial, comment: "Tax", force: :cascade do |t|
    t.string "name", null: false, comment: "Tax Name"
    t.string "type_tax_use", null: false, comment: "Tax Scope"
    t.boolean "tax_adjustment", comment: "Tax Adjustment"
    t.string "amount_type", null: false, comment: "Tax Computation"
    t.boolean "active", comment: "Active"
    t.integer "company_id", null: false, comment: "Company"
    t.integer "sequence", null: false, comment: "Sequence"
    t.decimal "amount", null: false, comment: "Amount"
    t.integer "account_id", comment: "Tax Account"
    t.integer "refund_account_id", comment: "Tax Account on Credit Notes"
    t.string "description", comment: "Label on Invoices"
    t.boolean "price_include", comment: "Included in Price"
    t.boolean "include_base_amount", comment: "Affect Base of Subsequent Taxes"
    t.boolean "analytic", comment: "Include in Analytic Cost"
    t.integer "tax_group_id", null: false, comment: "Tax Group"
    t.string "tax_exigibility", comment: "Tax Due"
    t.integer "cash_basis_account", comment: "Tax Received Account"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "cash_basis_base_account_id", comment: "Base Tax Received Account"
    t.index ["name", "company_id", "type_tax_use"], name: "account_tax_name_company_uniq", unique: true
  end

  create_table "account_tax_account_tag", id: false, comment: "RELATION BETWEEN account_tax AND account_account_tag", force: :cascade do |t|
    t.integer "account_tax_id", null: false
    t.integer "account_account_tag_id", null: false
    t.index ["account_account_tag_id"], name: "account_tax_account_tag_account_account_tag_id_idx"
    t.index ["account_tax_id", "account_account_tag_id"], name: "account_tax_account_tag_account_tax_id_account_account_tag__key", unique: true
    t.index ["account_tax_id"], name: "account_tax_account_tag_account_tax_id_idx"
  end

  create_table "account_tax_filiation_rel", id: false, comment: "RELATION BETWEEN account_tax AND account_tax", force: :cascade do |t|
    t.integer "parent_tax", null: false
    t.integer "child_tax", null: false
    t.index ["child_tax"], name: "account_tax_filiation_rel_child_tax_idx"
    t.index ["parent_tax", "child_tax"], name: "account_tax_filiation_rel_parent_tax_child_tax_key", unique: true
    t.index ["parent_tax"], name: "account_tax_filiation_rel_parent_tax_idx"
  end

  create_table "account_tax_group", id: :serial, comment: "account.tax.group", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_tax_pos_order_line_rel", id: false, comment: "RELATION BETWEEN pos_order_line AND account_tax", force: :cascade do |t|
    t.integer "pos_order_line_id", null: false
    t.integer "account_tax_id", null: false
    t.index ["account_tax_id"], name: "account_tax_pos_order_line_rel_account_tax_id_idx"
    t.index ["pos_order_line_id", "account_tax_id"], name: "account_tax_pos_order_line_re_pos_order_line_id_account_tax_key", unique: true
    t.index ["pos_order_line_id"], name: "account_tax_pos_order_line_rel_pos_order_line_id_idx"
  end

  create_table "account_tax_report", id: :serial, comment: "Tax Report", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "account_tax_sale_advance_payment_inv_rel", id: false, comment: "RELATION BETWEEN sale_advance_payment_inv AND account_tax", force: :cascade do |t|
    t.integer "sale_advance_payment_inv_id", null: false
    t.integer "account_tax_id", null: false
    t.index ["account_tax_id"], name: "account_tax_sale_advance_payment_inv_rel_account_tax_id_idx"
    t.index ["sale_advance_payment_inv_id", "account_tax_id"], name: "account_tax_sale_advance_paym_sale_advance_payment_inv_id_a_key", unique: true
    t.index ["sale_advance_payment_inv_id"], name: "account_tax_sale_advance_paymen_sale_advance_payment_inv_id_idx"
  end

  create_table "account_tax_sale_order_line_rel", id: false, comment: "RELATION BETWEEN sale_order_line AND account_tax", force: :cascade do |t|
    t.integer "sale_order_line_id", null: false
    t.integer "account_tax_id", null: false
    t.index ["account_tax_id"], name: "account_tax_sale_order_line_rel_account_tax_id_idx"
    t.index ["sale_order_line_id", "account_tax_id"], name: "account_tax_sale_order_line_r_sale_order_line_id_account_ta_key", unique: true
    t.index ["sale_order_line_id"], name: "account_tax_sale_order_line_rel_sale_order_line_id_idx"
  end

  create_table "account_tax_template", id: :serial, comment: "Templates for Taxes", force: :cascade do |t|
    t.integer "chart_template_id", null: false, comment: "Chart Template"
    t.string "name", null: false, comment: "Tax Name"
    t.string "type_tax_use", null: false, comment: "Tax Scope"
    t.boolean "tax_adjustment", comment: "Tax Adjustment"
    t.string "amount_type", null: false, comment: "Tax Computation"
    t.boolean "active", comment: "Active"
    t.integer "company_id", comment: "Company"
    t.integer "sequence", null: false, comment: "Sequence"
    t.decimal "amount", null: false, comment: "Amount"
    t.integer "account_id", comment: "Tax Account"
    t.integer "refund_account_id", comment: "Tax Account on Refunds"
    t.string "description", comment: "Display on Invoices"
    t.boolean "price_include", comment: "Included in Price"
    t.boolean "include_base_amount", comment: "Affect Subsequent Taxes"
    t.boolean "analytic", comment: "Analytic Cost"
    t.integer "tax_group_id", comment: "Tax Group"
    t.string "tax_exigibility", comment: "Tax Due"
    t.integer "cash_basis_account", comment: "Tax Received Account"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name", "company_id", "type_tax_use", "chart_template_id"], name: "account_tax_template_name_company_uniq", unique: true
  end

  create_table "account_tax_template_filiation_rel", id: false, comment: "RELATION BETWEEN account_tax_template AND account_tax_template", force: :cascade do |t|
    t.integer "parent_tax", null: false
    t.integer "child_tax", null: false
    t.index ["child_tax"], name: "account_tax_template_filiation_rel_child_tax_idx"
    t.index ["parent_tax", "child_tax"], name: "account_tax_template_filiation_rel_parent_tax_child_tax_key", unique: true
    t.index ["parent_tax"], name: "account_tax_template_filiation_rel_parent_tax_idx"
  end

  create_table "account_unreconcile", id: :serial, comment: "Account Unreconcile", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "accounting_report", id: :serial, comment: "Accounting Report", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.date "date_from", comment: "Start Date"
    t.date "date_to", comment: "End Date"
    t.string "target_move", null: false, comment: "Target Moves"
    t.boolean "enable_filter", comment: "Enable Comparison"
    t.integer "account_report_id", null: false, comment: "Account Reports"
    t.string "label_filter", comment: "Column Label"
    t.string "filter_cmp", null: false, comment: "Filter by"
    t.date "date_from_cmp", comment: "Start Date"
    t.date "date_to_cmp", comment: "End Date"
    t.boolean "debit_credit", comment: "Display Debit/Credit Columns"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admission_analysis", id: :serial, comment: "admission.analysis", force: :cascade do |t|
    t.integer "course_id", null: false, comment: "Course"
    t.date "start_date", null: false, comment: "Start Date"
    t.date "end_date", null: false, comment: "End Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "admission_sent_email", id: :serial, comment: "admission.sent.email", force: :cascade do |t|
    t.integer "batch_id", null: false, comment: "Batch"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "student_id", null: false, comment: "Student"
  end

  create_table "answer_marks", force: :cascade do |t|
    t.bigint "user_answer_id"
    t.text "mark_content"
    t.boolean "answer_is_right"
    t.bigint "teacher_id"
    t.datetime "mark_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["teacher_id"], name: "index_answer_marks_on_teacher_id"
    t.index ["user_answer_id"], name: "index_answer_marks_on_user_answer_id"
  end

  create_table "asset_depreciation_confirmation_wizard", id: :serial, comment: "asset.depreciation.confirmation.wizard", force: :cascade do |t|
    t.date "date", null: false, comment: "Account Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "asset_mass_create", id: :serial, comment: "Mass create new asset records", force: :cascade do |t|
    t.string "model_name", comment: "Model Name"
    t.binary "image_medium", comment: "Image"
    t.string "ac_prefix", comment: "Prefix"
    t.string "ac_suffix", comment: "Suffix"
    t.integer "ac_padding", null: false, comment: "Sequence Size"
    t.integer "ac_start", null: false, comment: "Code Start From"
    t.integer "quantity", null: false, comment: "Asset Quantity"
    t.float "purchase_value", comment: "Purchase Value"
    t.date "purchase_date", comment: "Purchase Date"
    t.integer "current_loc_id", null: false, comment: "Current Location"
    t.string "serial_no", comment: "Serial No"
    t.integer "asset_status_id", comment: "Status"
    t.integer "category_id", comment: "Category"
    t.string "manufacturer", comment: "Manufacturer"
    t.date "warranty_start", comment: "Warranty Start"
    t.date "warranty_end", comment: "Warranty End"
    t.text "note", comment: "Internal Notes"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.binary "image", comment: "Image"
  end

  create_table "asset_modify", id: :serial, comment: "Modify Asset", force: :cascade do |t|
    t.text "name", null: false, comment: "Reason"
    t.integer "method_number", null: false, comment: "Number of Depreciations"
    t.integer "method_period", comment: "Period Length"
    t.date "method_end", comment: "Ending date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "asset_move", id: :serial, comment: "asset.move", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "from_loc_id", null: false, comment: "From Location"
    t.integer "asset_id", comment: "Asset"
    t.integer "to_loc_id", comment: "To Location"
    t.datetime "borrow_date", comment: "Borrow Date"
    t.datetime "pay_date", comment: "Pay Date"
    t.datetime "actual_date", comment: "Actual Date"
    t.float "quantity", comment: "Quantity"
    t.float "penalty", comment: "Penalty"
    t.boolean "move", comment: "Move"
    t.datetime "move_date", comment: "Date move"
    t.string "person", comment: "Student/Faculty/Employee"
    t.integer "student_id", comment: "Student"
    t.integer "faculty_id", comment: "Faculty"
    t.integer "employee_id", comment: "Employee"
    t.integer "manager_id", comment: "Manager"
    t.string "state", comment: "State"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.text "note", comment: "Note"
    t.text "employee_note", comment: "Note"
    t.integer "manager_faculty_id", comment: "Manager"
    t.string "status", comment: "Status"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.string "asset_location", comment: "Asset Location"
    t.integer "batch_id", comment: "Batch"
    t.integer "course_id", comment: "Course"
    t.integer "company_id", comment: "Company"
    t.string "note_for_faculty", comment: "Note"
  end

  create_table "asset_move_bt_asset_rel", id: false, comment: "RELATION BETWEEN bt_asset AND asset_move", force: :cascade do |t|
    t.integer "bt_asset_id", null: false
    t.integer "asset_move_id", null: false
    t.index ["asset_move_id"], name: "asset_move_bt_asset_rel_asset_move_id_idx"
    t.index ["bt_asset_id", "asset_move_id"], name: "asset_move_bt_asset_rel_bt_asset_id_asset_move_id_key", unique: true
    t.index ["bt_asset_id"], name: "asset_move_bt_asset_rel_bt_asset_id_idx"
  end

  create_table "asset_table", id: :serial, comment: "asset.table", force: :cascade do |t|
    t.string "group", comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "name", comment: "Name"
  end

  create_table "assign_lead", id: :serial, comment: "assign.lead", force: :cascade do |t|
    t.integer "team_id", comment: "Sales Channel"
    t.integer "user_id", comment: "Sales Person"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "stage_id", comment: "Stage"
  end

  create_table "attendance_company_rel", id: false, comment: "RELATION BETWEEN export_attendance AND res_company", force: :cascade do |t|
    t.integer "atten_id", null: false
    t.integer "com_id", null: false
    t.index ["atten_id", "com_id"], name: "attendance_company_rel_atten_id_com_id_key", unique: true
    t.index ["atten_id"], name: "attendance_company_rel_atten_id_idx"
    t.index ["com_id"], name: "attendance_company_rel_com_id_idx"
  end

  create_table "attendance_device_zk", id: :serial, comment: "attendance.device.zk", force: :cascade do |t|
    t.string "ip", comment: "Machine IP"
    t.integer "port", comment: "Port"
    t.integer "company_id", comment: "Company"
    t.integer "passwd", comment: "Password"
    t.boolean "create_employee", comment: "Create employee if not exist"
    t.integer "limit_record", comment: "Limit Record"
    t.integer "sleep", comment: "Sleep time (second)"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "attendance_device_zk_line", id: :serial, comment: "attendance.device.zk.line", force: :cascade do |t|
    t.integer "zk_id", comment: "Zk"
    t.datetime "time_run", comment: "Time Run"
    t.string "log", comment: "Log"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "attendance_employee_rel", id: false, comment: "RELATION BETWEEN export_attendance AND hr_employee", force: :cascade do |t|
    t.integer "atten_id", null: false
    t.integer "emp_id", null: false
    t.index ["atten_id", "emp_id"], name: "attendance_employee_rel_atten_id_emp_id_key", unique: true
    t.index ["atten_id"], name: "attendance_employee_rel_atten_id_idx"
    t.index ["emp_id"], name: "attendance_employee_rel_emp_id_idx"
  end

  create_table "attendance_report", id: :serial, comment: "Attendance report", force: :cascade do |t|
    t.string "name", comment: "Tên"
    t.boolean "active", comment: "Active"
    t.integer "employee_id", comment: "Nhân viên"
    t.integer "device_code", comment: "Mã vân tay"
    t.string "shift_work", comment: "Khối"
    t.integer "company_id", comment: "Công ty"
    t.float "standard_day", comment: "Ngày công tiêu chuẩn"
    t.float "attend", comment: "Ngày công thực tế"
    t.float "allowed_vacation", comment: "Nghỉ có xin phép"
    t.float "day_off", comment: "Nghỉ không xin phép"
    t.integer "late_in", comment: "Đến muộn"
    t.integer "early_out", comment: "Về sớm"
    t.integer "login_forget", comment: "Không log in"
    t.integer "logout_forget", comment: "Không log out"
    t.integer "attendance_forget", comment: "Số lần quên chấm công"
    t.float "normal_day", comment: "Ngày thường"
    t.float "last_weekend", comment: "Ngày nghỉ"
    t.float "holiday", comment: "Ngày lễ"
    t.date "start_date", comment: "Từ ngày"
    t.date "end_date", comment: "Tới ngày"
    t.integer "total_day", comment: "Tổng số ngày"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "job_id", comment: "Vị trí công việc"
    t.integer "id_employee", comment: "ID Employee"
    t.float "leave", comment: "ĐK nghỉ: Nghỉ phép"
    t.text "ccbs_moved0", comment: "ĐK nghỉ: Chấm công bổ sung"
    t.integer "ccbs", comment: "Số lần làm chấm công bổ sung"
    t.float "hours_of_ctv", comment: "Số giờ của CTV"
    t.string "employee_code", comment: "Mã nhân viên"
  end

  create_table "attendance_tutor", id: :serial, comment: "attendance.tutor", force: :cascade do |t|
    t.integer "tutor_id", comment: "Tutor"
    t.boolean "present", comment: "Present ?"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "batch"
    t.integer "session_id", comment: "Session"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "auth_oauth_provider", id: :serial, comment: "OAuth2 provider", force: :cascade do |t|
    t.string "name", null: false, comment: "Provider name"
    t.string "client_id", comment: "Client ID"
    t.string "auth_endpoint", null: false, comment: "Authentication URL"
    t.string "scope", comment: "Scope"
    t.string "validation_endpoint", null: false, comment: "Validation URL"
    t.string "data_endpoint", comment: "Data URL"
    t.boolean "enabled", comment: "Allowed"
    t.string "css_class", comment: "CSS class"
    t.string "body", null: false, comment: "Body"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "avatars", force: :cascade do |t|
    t.string "gender"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "badge_unlocked_definition_rel", id: false, comment: "RELATION BETWEEN gamification_badge AND gamification_goal_definition", force: :cascade do |t|
    t.integer "gamification_badge_id", null: false
    t.integer "gamification_goal_definition_id", null: false
    t.index ["gamification_badge_id", "gamification_goal_definition_id"], name: "badge_unlocked_definition_rel_gamification_badge_id_gamific_key", unique: true
    t.index ["gamification_badge_id"], name: "badge_unlocked_definition_rel_gamification_badge_id_idx"
    t.index ["gamification_goal_definition_id"], name: "badge_unlocked_definition_rel_gamification_goal_definition__idx"
  end

  create_table "barcode_nomenclature", id: :serial, comment: "barcode.nomenclature", force: :cascade do |t|
    t.string "name", limit: 32, null: false, comment: "Nomenclature Name"
    t.string "upc_ean_conv", null: false, comment: "UPC/EAN Conversion"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "barcode_rule", id: :serial, comment: "barcode.rule", force: :cascade do |t|
    t.string "name", limit: 32, null: false, comment: "Rule Name"
    t.integer "barcode_nomenclature_id", comment: "Barcode Nomenclature"
    t.integer "sequence", comment: "Sequence"
    t.string "encoding", null: false, comment: "Encoding"
    t.string "type", null: false, comment: "Type"
    t.string "pattern", limit: 32, null: false, comment: "Barcode Pattern"
    t.string "alias", limit: 32, null: false, comment: "Alias"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_automation", id: :serial, comment: "Automated Action", force: :cascade do |t|
    t.integer "action_server_id", null: false, comment: "Server Actions"
    t.boolean "active", comment: "Active"
    t.string "trigger", null: false, comment: "Trigger Condition"
    t.integer "trg_date_id", comment: "Trigger Date"
    t.integer "trg_date_range", comment: "Delay after trigger date"
    t.string "trg_date_range_type", comment: "Delay type"
    t.integer "trg_date_calendar_id", comment: "Use Calendar"
    t.string "filter_pre_domain", comment: "Before Update Domain"
    t.string "filter_domain", comment: "Apply on"
    t.datetime "last_run", comment: "Last Run"
    t.string "on_change_fields", comment: "On Change Fields Trigger"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_automation_lead_test", id: :serial, comment: "Action Rule Test", force: :cascade do |t|
    t.string "name", null: false, comment: "Subject"
    t.integer "user_id", comment: "Responsible"
    t.string "state", comment: "Status"
    t.boolean "active", comment: "Active"
    t.integer "partner_id", comment: "Partner"
    t.datetime "date_action_last", comment: "Last Action"
    t.boolean "customer", comment: "Is a Customer"
    t.boolean "priority", comment: "Priority"
    t.boolean "deadline", comment: "Deadline"
    t.boolean "is_assigned_to_admin", comment: "Assigned to admin user"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "base_automation_lead_test_name_index"
  end

  create_table "base_automation_line_test", id: :serial, comment: "Action Rule Line Test", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "lead_id", comment: "Lead"
    t.integer "user_id", comment: "User"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_import", id: :serial, comment: "base_import.import", force: :cascade do |t|
    t.string "res_model", comment: "Model"
    t.binary "file", comment: "File"
    t.string "file_name", comment: "File Name"
    t.string "file_type", comment: "File Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_char", id: :serial, comment: "base_import.tests.models.char", force: :cascade do |t|
    t.string "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_char_noreadonly", id: :serial, comment: "base_import.tests.models.char.noreadonly", force: :cascade do |t|
    t.string "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_char_readonly", id: :serial, comment: "base_import.tests.models.char.readonly", force: :cascade do |t|
    t.string "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_char_required", id: :serial, comment: "base_import.tests.models.char.required", force: :cascade do |t|
    t.string "value", null: false, comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_char_states", id: :serial, comment: "base_import.tests.models.char.states", force: :cascade do |t|
    t.string "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_char_stillreadonly", id: :serial, comment: "base_import.tests.models.char.stillreadonly", force: :cascade do |t|
    t.string "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_m2o", id: :serial, comment: "base_import.tests.models.m2o", force: :cascade do |t|
    t.integer "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_m2o_related", id: :serial, comment: "base_import.tests.models.m2o.related", force: :cascade do |t|
    t.integer "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_m2o_required", id: :serial, comment: "base_import.tests.models.m2o.required", force: :cascade do |t|
    t.integer "value", null: false, comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_m2o_required_related", id: :serial, comment: "base_import.tests.models.m2o.required.related", force: :cascade do |t|
    t.integer "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_o2m", id: :serial, comment: "base_import.tests.models.o2m", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_o2m_child", id: :serial, comment: "base_import.tests.models.o2m.child", force: :cascade do |t|
    t.integer "parent_id", comment: "Parent"
    t.integer "value", comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_import_tests_models_preview", id: :serial, comment: "base_import.tests.models.preview", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "somevalue", null: false, comment: "Some Value"
    t.integer "othervalue", comment: "Other Variable"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_language_export", id: :serial, comment: "base.language.export", force: :cascade do |t|
    t.string "name", comment: "File Name"
    t.string "lang", null: false, comment: "Language"
    t.string "format", null: false, comment: "File Format"
    t.binary "data", comment: "File"
    t.string "state", comment: "State"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_language_import", id: :serial, comment: "Language Import", force: :cascade do |t|
    t.string "name", null: false, comment: "Language Name"
    t.string "code", limit: 5, null: false, comment: "ISO Code"
    t.binary "data", null: false, comment: "File"
    t.string "filename", null: false, comment: "File Name"
    t.boolean "overwrite", comment: "Overwrite Existing Terms"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_language_install", id: :serial, comment: "Install Language", force: :cascade do |t|
    t.string "lang", null: false, comment: "Language"
    t.boolean "overwrite", comment: "Overwrite Existing Terms"
    t.string "state", comment: "Status"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_language_install_website_rel", id: false, comment: "RELATION BETWEEN base_language_install AND website", force: :cascade do |t|
    t.integer "base_language_install_id", null: false
    t.integer "website_id", null: false
    t.index ["base_language_install_id", "website_id"], name: "base_language_install_website_base_language_install_id_webs_key", unique: true
    t.index ["base_language_install_id"], name: "base_language_install_website_rel_base_language_install_id_idx"
    t.index ["website_id"], name: "base_language_install_website_rel_website_id_idx"
  end

  create_table "base_language_update", id: :serial, comment: "base.language.update", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_language_update_ir_module_module_rel", id: false, comment: "RELATION BETWEEN base_language_update AND ir_module_module", force: :cascade do |t|
    t.integer "base_language_update_id", null: false
    t.integer "ir_module_module_id", null: false
    t.index ["base_language_update_id", "ir_module_module_id"], name: "base_language_update_ir_modul_base_language_update_id_ir_mo_key", unique: true
    t.index ["base_language_update_id"], name: "base_language_update_ir_module_modu_base_language_update_id_idx"
    t.index ["ir_module_module_id"], name: "base_language_update_ir_module_module_r_ir_module_module_id_idx"
  end

  create_table "base_module_uninstall", id: :serial, comment: "Module Uninstallation", force: :cascade do |t|
    t.boolean "show_all", comment: "Show All"
    t.integer "module_id", null: false, comment: "Module"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_module_update", id: :serial, comment: "Update Module", force: :cascade do |t|
    t.integer "updated", comment: "Number of modules updated"
    t.integer "added", comment: "Number of modules added"
    t.string "state", comment: "Status"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_module_upgrade", id: :serial, comment: "Module Upgrade", force: :cascade do |t|
    t.text "module_info", comment: "Apps to Update"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_partner_merge_automatic_wizard", id: :serial, comment: "base.partner.merge.automatic.wizard", force: :cascade do |t|
    t.boolean "group_by_email", comment: "Email"
    t.boolean "group_by_name", comment: "Name"
    t.boolean "group_by_is_company", comment: "Is Company"
    t.boolean "group_by_vat", comment: "VAT"
    t.boolean "group_by_parent_id", comment: "Parent Company"
    t.string "state", null: false, comment: "State"
    t.integer "number_group", comment: "Group of Contacts"
    t.integer "current_line_id", comment: "Current Line"
    t.integer "dst_partner_id", comment: "Destination Contact"
    t.boolean "exclude_contact", comment: "A user associated to the contact"
    t.boolean "exclude_journal_item", comment: "Journal Items associated to the contact"
    t.integer "maximum_group", comment: "Maximum of Group of Contacts"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_partner_merge_automatic_wizard_res_partner_rel", id: false, comment: "RELATION BETWEEN base_partner_merge_automatic_wizard AND res_partner", force: :cascade do |t|
    t.integer "base_partner_merge_automatic_wizard_id", null: false
    t.integer "res_partner_id", null: false
    t.index ["base_partner_merge_automatic_wizard_id", "res_partner_id"], name: "base_partner_merge_automatic__base_partner_merge_automatic__key", unique: true
    t.index ["base_partner_merge_automatic_wizard_id"], name: "base_partner_merge_automatic__base_partner_merge_automatic__idx"
    t.index ["res_partner_id"], name: "base_partner_merge_automatic_wizard_res_part_res_partner_id_idx"
  end

  create_table "base_partner_merge_line", id: :serial, comment: "base.partner.merge.line", force: :cascade do |t|
    t.integer "wizard_id", comment: "Wizard"
    t.integer "min_id", comment: "MinID"
    t.string "aggr_ids", null: false, comment: "Ids"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "base_update_translations", id: :serial, comment: "base.update.translations", force: :cascade do |t|
    t.string "lang", null: false, comment: "Language"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "batch_reject_wizard", id: :serial, comment: "batch.reject.wizard", force: :cascade do |t|
    t.text "reason", null: false, comment: "Rejecting Reason"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "broadcast_noti", force: :cascade do |t|
    t.text "content"
    t.text "title"
    t.integer "created_by"
    t.datetime "expiry_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "broadcast_noti_state", force: :cascade do |t|
    t.boolean "status"
    t.integer "broadcast_notice_id"
    t.integer "user_id"
    t.datetime "read_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bt_asset", id: :serial, comment: "Asset", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.date "purchase_date", comment: "Purchase Date"
    t.float "purchase_value", comment: "Purchase Value"
    t.string "asset_code", comment: "Asset Code"
    t.boolean "is_created", comment: "Created"
    t.integer "current_loc_id", null: false, comment: "Current Location"
    t.string "model_name", comment: "Model Name"
    t.string "serial_no", comment: "Serial No"
    t.string "manufacturer", comment: "Manufacturer"
    t.date "warranty_start", comment: "Warranty Start"
    t.date "warranty_end", comment: "Warranty End"
    t.integer "category_id", comment: "Category Id"
    t.text "note", comment: "Internal Notes"
    t.string "state", comment: "State"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.float "quantity", comment: "Quantity"
    t.integer "asset_status_id", comment: "Tình trạng thiết bị"
    t.integer "company_id", comment: "Company"
    t.string "asset_state", comment: "Hiện trạng"
    t.integer "categ_id", comment: "Category"
    t.integer "asset_table", comment: "Asset Table"
    t.integer "parent_id", comment: "Parent Category"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.text "comment", comment: "Comment"
  end

  create_table "bt_asset_category", id: :serial, comment: "Asset Category", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "categ_no", comment: "Category No"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "parent_id", comment: "Parent Category"
    t.index ["parent_id"], name: "bt_asset_category_parent_id_index"
  end

  create_table "bt_asset_location", id: :serial, comment: "Asset Location", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.boolean "default", comment: "Default"
    t.boolean "default_scrap", comment: "Scrap"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "bt_asset_move", id: :serial, comment: "Asset Move", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "from_loc_id", null: false, comment: "From Location"
    t.integer "asset_id", comment: "Asset"
    t.integer "to_loc_id", null: false, comment: "To Location"
    t.string "state", comment: "State"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "bt_asset_status", id: :serial, comment: "bt.asset.status", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.boolean "active", comment: "Active"
    t.text "note", comment: "Note"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "bt_asset_status_name_index"
  end

  create_table "bt_hr_overtime", id: :serial, comment: "Bt Hr Overtime", force: :cascade do |t|
    t.integer "employee_id", comment: "Employee"
    t.date "start_date", comment: "Date"
    t.float "overtime_hours", comment: "Overtime Hours"
    t.text "notes", comment: "Notes"
    t.string "state", comment: "State"
    t.integer "attendance_id", comment: "Attendance"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "manager_id", comment: "Manager"
    t.integer "company_id", comment: "Company"
    t.date "overtime_date", comment: "Ngày OT"
    t.string "type_of_day", comment: "Ngày OT"
  end

  create_table "bus_bus", id: :serial, comment: "bus.bus", force: :cascade do |t|
    t.datetime "create_date", comment: "Create date"
    t.string "channel", comment: "Channel"
    t.string "message", comment: "Message"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "bus_presence", id: :serial, comment: "User Presence", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "Users"
    t.datetime "last_poll", comment: "Last Poll"
    t.datetime "last_presence", comment: "Last Presence"
    t.string "status", comment: "IM Status"
    t.index ["user_id"], name: "bus_presence_bus_user_presence_unique", unique: true
    t.index ["user_id"], name: "bus_presence_user_id_index"
  end

  create_table "bve_view", id: :serial, comment: "BI View Editor", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "model_name", comment: "Model Name"
    t.text "note", comment: "Notes"
    t.string "state", comment: "State"
    t.text "data", comment: "Data"
    t.integer "action_id", comment: "Action"
    t.integer "view_id", comment: "View"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "calendar_alarm", id: :serial, comment: "Event alarm", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "type", null: false, comment: "Type"
    t.integer "duration", null: false, comment: "Remind Before"
    t.string "interval", null: false, comment: "Unit"
    t.integer "duration_minutes", comment: "Duration in minutes"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "calendar_alarm_calendar_event_rel", id: false, comment: "RELATION BETWEEN calendar_event AND calendar_alarm", force: :cascade do |t|
    t.integer "calendar_event_id", null: false
    t.integer "calendar_alarm_id", null: false
    t.index ["calendar_alarm_id"], name: "calendar_alarm_calendar_event_rel_calendar_alarm_id_idx"
    t.index ["calendar_event_id", "calendar_alarm_id"], name: "calendar_alarm_calendar_event_calendar_event_id_calendar_al_key", unique: true
    t.index ["calendar_event_id"], name: "calendar_alarm_calendar_event_rel_calendar_event_id_idx"
  end

  create_table "calendar_attendee", id: :serial, comment: "Attendee information", force: :cascade do |t|
    t.string "state", comment: "Status"
    t.string "common_name", comment: "Common name"
    t.integer "partner_id", comment: "Contact"
    t.string "email", comment: "Email"
    t.string "availability", comment: "Free/Busy"
    t.string "access_token", comment: "Invitation Token"
    t.integer "event_id", comment: "Meeting linked"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "google_internal_event_id", comment: "Google Calendar Event Id"
    t.datetime "oe_synchro_date", comment: "Odoo Synchro Date"
    t.index ["google_internal_event_id", "partner_id", "event_id"], name: "calendar_attendee_google_id_uniq", unique: true
  end

  create_table "calendar_contacts", id: :serial, comment: "calendar.contacts", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "Me"
    t.integer "partner_id", null: false, comment: "Employee"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["user_id", "partner_id"], name: "calendar_contacts_user_id_partner_id_unique", unique: true
  end

  create_table "calendar_event", id: :serial, comment: "Event", force: :cascade do |t|
    t.string "name", null: false, comment: "Meeting Subject"
    t.string "state", comment: "Status"
    t.string "display_start", comment: "Date"
    t.datetime "start", null: false, comment: "Start"
    t.datetime "stop", null: false, comment: "Stop"
    t.boolean "allday", comment: "All Day"
    t.date "start_date", comment: "Start Date"
    t.datetime "start_datetime", comment: "Start DateTime"
    t.date "stop_date", comment: "End Date"
    t.datetime "stop_datetime", comment: "End Datetime"
    t.float "duration", comment: "Duration"
    t.text "description", comment: "Description"
    t.string "privacy", comment: "Privacy"
    t.string "location", comment: "Location"
    t.string "show_as", comment: "Show Time as"
    t.integer "res_id", comment: "Document ID"
    t.integer "res_model_id", comment: "Document Model"
    t.string "res_model", comment: "Document Model Name"
    t.string "rrule", comment: "Recurrent Rule"
    t.string "rrule_type", comment: "Recurrence"
    t.boolean "recurrency", comment: "Recurrent"
    t.integer "recurrent_id", comment: "Recurrent ID"
    t.datetime "recurrent_id_date", comment: "Recurrent ID date"
    t.string "end_type", comment: "Recurrence Termination"
    t.integer "interval", comment: "Repeat Every"
    t.integer "count", comment: "Repeat"
    t.boolean "mo", comment: "Mon"
    t.boolean "tu", comment: "Tue"
    t.boolean "we", comment: "Wed"
    t.boolean "th", comment: "Thu"
    t.boolean "fr", comment: "Fri"
    t.boolean "sa", comment: "Sat"
    t.boolean "su", comment: "Sun"
    t.string "month_by", comment: "Option"
    t.integer "day", comment: "Date of month"
    t.string "week_list", comment: "Weekday"
    t.string "byday", comment: "By day"
    t.date "final_date", comment: "Repeat Until"
    t.integer "user_id", comment: "Responsible"
    t.boolean "active", comment: "Active"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "opportunity_id", comment: "Opportunity"
    t.integer "applicant_id", comment: "Applicant"
    t.datetime "oe_update_date", comment: "Odoo Update Date"
    t.boolean "will_participate", comment: "Will participate"
    t.integer "phonecall_id", comment: "Phonecall"
  end

  create_table "calendar_event_res_partner_rel", id: false, comment: "RELATION BETWEEN calendar_event AND res_partner", force: :cascade do |t|
    t.integer "calendar_event_id", null: false
    t.integer "res_partner_id", null: false
    t.index ["calendar_event_id", "res_partner_id"], name: "calendar_event_res_partner_re_calendar_event_id_res_partner_key", unique: true
    t.index ["calendar_event_id"], name: "calendar_event_res_partner_rel_calendar_event_id_idx"
    t.index ["res_partner_id"], name: "calendar_event_res_partner_rel_res_partner_id_idx"
  end

  create_table "calendar_event_type", id: :serial, comment: "Meeting Type", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "calendar_event_type_name_uniq", unique: true
  end

  create_table "cash_box_in", id: :serial, comment: "cash.box.in", force: :cascade do |t|
    t.string "name", null: false, comment: "Reason"
    t.decimal "amount", null: false, comment: "Amount"
    t.string "ref", comment: "Reference"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "cash_box_out", id: :serial, comment: "cash.box.out", force: :cascade do |t|
    t.string "name", null: false, comment: "Reason"
    t.decimal "amount", null: false, comment: "Amount"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "change_password_user", id: :serial, comment: "Change Password Wizard User", force: :cascade do |t|
    t.integer "wizard_id", null: false, comment: "Wizard"
    t.integer "user_id", null: false, comment: "User"
    t.string "user_login", comment: "User Login"
    t.string "new_passwd", comment: "New Password"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "change_password_wizard", id: :serial, comment: "Change Password Wizard", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "coin_star_transactions", force: :cascade do |t|
    t.bigint "give_to"
    t.bigint "give_by"
    t.bigint "activity_id"
    t.string "activity_type", limit: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_coin_star_transactions_on_activity_id"
    t.index ["activity_type"], name: "index_coin_star_transactions_on_activity_type"
    t.index ["give_by"], name: "index_coin_star_transactions_on_give_by"
    t.index ["give_to"], name: "index_coin_star_transactions_on_give_to"
  end

  create_table "comments", comment: "table comment ve mot noi dung cua nguoi dung", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false, comment: "id cua noi dung comment"
    t.string "post_type", limit: 10, comment: "loai noi dung comment: batch; album; photo;lesson"
    t.bigint "parent_comment_id", comment: "id comment cha"
    t.text "content", comment: "noi dung comment"
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "course_categ", id: :serial, comment: "course.categ", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "course_description", force: :cascade do |t|
    t.bigint "op_course_id"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["op_course_id"], name: "index_course_description_on_op_course_id"
  end

  create_table "crm_claim", id: :serial, comment: "Claim", force: :cascade do |t|
    t.string "name", null: false, comment: "Claim Subject"
    t.boolean "active", comment: "Active"
    t.text "description", comment: "Description"
    t.text "resolution", comment: "Resolution"
    t.datetime "create_date", comment: "Creation Date"
    t.datetime "write_date", comment: "Update Date"
    t.date "date_deadline", comment: "Deadline"
    t.datetime "date_closed", comment: "Closed"
    t.datetime "date", comment: "Claim Date"
    t.string "model_ref_id", comment: "Reference"
    t.integer "categ_id", comment: "Category"
    t.string "priority", comment: "Priority"
    t.string "type_action", comment: "Action Type"
    t.integer "user_id", comment: "Responsible"
    t.string "user_fault", comment: "Trouble Responsible"
    t.integer "team_id", comment: "Sales Team"
    t.integer "company_id", comment: "Company"
    t.integer "partner_id", comment: "Partner"
    t.text "email_cc", comment: "Watchers Emails"
    t.string "email_from", comment: "Email"
    t.string "partner_phone", comment: "Phone"
    t.integer "stage_id", comment: "Stage"
    t.text "cause", comment: "Root Cause"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.integer "student_id", comment: "Student"
    t.string "admission_mode", comment: "Admission Mode"
    t.integer "from_company_id", comment: "From Center"
    t.integer "from_course_id", comment: "From Course"
    t.integer "from_batch_id", comment: "From Batch"
    t.integer "to_company_id", comment: "To Center"
    t.integer "to_course_id", comment: "To Course"
    t.integer "to_batch_id", comment: "To Batch"
    t.string "code", null: false
    t.index ["code"], name: "crm_claim_crm_claim_unique_code", unique: true
    t.index ["date"], name: "crm_claim_date_index"
    t.index ["team_id"], name: "crm_claim_team_id_index"
  end

  create_table "crm_claim_category", id: :serial, comment: "Category of claim", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "team_id", comment: "Sales Team"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "need_create_admission", comment: "Need Create Admission"
    t.boolean "need_create_expense", comment: "Need Create Expense"
    t.boolean "need_confirm_by_bd", comment: "Need Confirm By Bd"
    t.boolean "need_cross_center_confirm", comment: "Need Cross Center Confirm"
  end

  create_table "crm_claim_rev", id: false, force: :cascade do |t|
    t.integer "id"
    t.text "name"
  end

  create_table "crm_claim_sale_order_rel", id: false, comment: "RELATION BETWEEN crm_claim AND sale_order", force: :cascade do |t|
    t.integer "crm_claim_id", null: false
    t.integer "sale_order_id", null: false
    t.index ["crm_claim_id", "sale_order_id"], name: "crm_claim_sale_order_rel_crm_claim_id_sale_order_id_key", unique: true
    t.index ["crm_claim_id"], name: "crm_claim_sale_order_rel_crm_claim_id_idx"
    t.index ["sale_order_id"], name: "crm_claim_sale_order_rel_sale_order_id_idx"
  end

  create_table "crm_claim_stage", id: :serial, comment: "Claim stages", force: :cascade do |t|
    t.string "name", null: false, comment: "Stage Name"
    t.integer "sequence", comment: "Sequence"
    t.boolean "case_default", comment: "Common to All Teams"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "state", comment: "State"
  end

  create_table "crm_lead", id: :serial, comment: "Lead/Opportunity", force: :cascade do |t|
    t.string "name", null: false, comment: "Opportunity"
    t.integer "partner_id", comment: "Customer"
    t.boolean "active", comment: "Active"
    t.datetime "date_action_last", comment: "Last Action"
    t.string "email_from", comment: "Email"
    t.string "website", comment: "Website"
    t.integer "team_id", comment: "Sales Channel"
    t.text "email_cc", comment: "Global CC"
    t.text "description", comment: "Notes"
    t.datetime "create_date", comment: "Create Date"
    t.datetime "write_date", comment: "Update Date"
    t.string "contact_name", comment: "Contact Name"
    t.string "partner_name", comment: "Customer Name"
    t.boolean "opt_out", comment: "Opt-Out"
    t.string "type", null: false, comment: "Type"
    t.string "priority", comment: "Priority"
    t.datetime "date_closed", comment: "Closed Date"
    t.integer "stage_id", comment: "Stage"
    t.integer "user_id", comment: "Salesperson"
    t.string "referred", comment: "Referred By"
    t.datetime "date_open", comment: "Assigned"
    t.float "day_open", comment: "Days to Assign"
    t.float "day_close", comment: "Days to Close"
    t.datetime "date_last_stage_update", comment: "Last Stage Update"
    t.datetime "date_conversion", comment: "Conversion Date"
    t.integer "message_bounce", comment: "Bounce"
    t.float "probability", comment: "Probability"
    t.float "planned_revenue", comment: "Expected Revenue"
    t.date "date_deadline", comment: "Expected Closing"
    t.integer "color", comment: "Color Index"
    t.string "street", comment: "Street"
    t.string "street2", comment: "Street2"
    t.string "zip", comment: "Zip"
    t.string "city", comment: "City"
    t.integer "state_id", comment: "State"
    t.integer "country_id", comment: "Country"
    t.string "phone", comment: "Phone"
    t.string "mobile", comment: "Mobile"
    t.string "function", comment: "Job Position"
    t.integer "title", comment: "Title"
    t.integer "company_id", comment: "Company"
    t.integer "lost_reason", comment: "Lost Reason"
    t.integer "campaign_id", comment: "Campaign"
    t.integer "source_id", comment: "Source"
    t.integer "medium_id", comment: "Medium"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "date_last_activity_deadline", comment: "Final Deadline"
    t.integer "convert_uid", comment: "Converted By"
    t.boolean "assigned_to_leader", comment: "Assign Leader"
    t.binary "file_name", comment: "Import your file"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.datetime "date_last_assign", comment: "Last Assigned"
    t.datetime "date_sale", comment: "First SO Confirmed"
    t.datetime "date_invoice", comment: "First SO Invoiced"
    t.boolean "cocall", comment: "Check Cocall"
    t.index ["company_id"], name: "crm_lead_company_id_index"
    t.index ["convert_uid"], name: "crm_lead_convert_uid_index"
    t.index ["date_last_stage_update"], name: "crm_lead_date_last_stage_update_index"
    t.index ["email_from"], name: "crm_lead_email_from_index"
    t.index ["lost_reason"], name: "crm_lead_lost_reason_index"
    t.index ["name"], name: "crm_lead_name_index"
    t.index ["partner_id"], name: "crm_lead_partner_id_index"
    t.index ["partner_name"], name: "crm_lead_partner_name_index"
    t.index ["priority"], name: "crm_lead_priority_index"
    t.index ["stage_id"], name: "crm_lead_stage_id_index"
    t.index ["team_id"], name: "crm_lead_team_id_index"
    t.index ["type"], name: "crm_lead_type_index"
    t.index ["user_id"], name: "crm_lead_user_id_index"
    t.index ["website"], name: "crm_lead_website_index"
  end

  create_table "crm_lead2opportunity_partner", id: :serial, comment: "Lead To Opportunity Partner", force: :cascade do |t|
    t.string "name", null: false, comment: "Conversion Action"
    t.integer "user_id", comment: "Salesperson"
    t.integer "team_id", comment: "Sales Channel"
    t.string "action", null: false, comment: "Related Customer"
    t.integer "partner_id", comment: "Customer"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["team_id"], name: "crm_lead2opportunity_partner_team_id_index"
    t.index ["user_id"], name: "crm_lead2opportunity_partner_user_id_index"
  end

  create_table "crm_lead2opportunity_partner_mass", id: :serial, comment: "Mass Lead To Opportunity Partner", force: :cascade do |t|
    t.integer "partner_id", comment: "Customer"
    t.string "name", null: false, comment: "Conversion Action"
    t.integer "user_id", comment: "Salesperson"
    t.integer "team_id", comment: "Sales Channel"
    t.boolean "deduplicate", comment: "Apply deduplication"
    t.string "action", null: false, comment: "Related Customer"
    t.boolean "force_assignation", comment: "Force assignation"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["team_id"], name: "crm_lead2opportunity_partner_mass_team_id_index"
    t.index ["user_id"], name: "crm_lead2opportunity_partner_mass_user_id_index"
  end

  create_table "crm_lead2opportunity_partner_mass_res_users_rel", id: false, comment: "RELATION BETWEEN crm_lead2opportunity_partner_mass AND res_users", force: :cascade do |t|
    t.integer "crm_lead2opportunity_partner_mass_id", null: false
    t.integer "res_users_id", null: false
    t.index ["crm_lead2opportunity_partner_mass_id", "res_users_id"], name: "crm_lead2opportunity_partner__crm_lead2opportunity_partner__key", unique: true
    t.index ["crm_lead2opportunity_partner_mass_id"], name: "crm_lead2opportunity_partner__crm_lead2opportunity_partner__idx"
    t.index ["res_users_id"], name: "crm_lead2opportunity_partner_mass_res_users_re_res_users_id_idx"
  end

  create_table "crm_lead_crm_lead2opportunity_partner_mass_rel", id: false, comment: "RELATION BETWEEN crm_lead2opportunity_partner_mass AND crm_lead", force: :cascade do |t|
    t.integer "crm_lead2opportunity_partner_mass_id", null: false
    t.integer "crm_lead_id", null: false
    t.index ["crm_lead2opportunity_partner_mass_id", "crm_lead_id"], name: "crm_lead_crm_lead2opportunity_crm_lead2opportunity_partner_key1", unique: true
    t.index ["crm_lead2opportunity_partner_mass_id"], name: "crm_lead_crm_lead2opportunity_crm_lead2opportunity_partner_idx1"
    t.index ["crm_lead_id"], name: "crm_lead_crm_lead2opportunity_partner_mass_rel_crm_lead_id_idx"
  end

  create_table "crm_lead_crm_lead2opportunity_partner_rel", id: false, comment: "RELATION BETWEEN crm_lead2opportunity_partner AND crm_lead", force: :cascade do |t|
    t.integer "crm_lead2opportunity_partner_id", null: false
    t.integer "crm_lead_id", null: false
    t.index ["crm_lead2opportunity_partner_id", "crm_lead_id"], name: "crm_lead_crm_lead2opportunity_crm_lead2opportunity_partner__key", unique: true
    t.index ["crm_lead2opportunity_partner_id"], name: "crm_lead_crm_lead2opportunity_crm_lead2opportunity_partner__idx"
    t.index ["crm_lead_id"], name: "crm_lead_crm_lead2opportunity_partner_rel_crm_lead_id_idx"
  end

  create_table "crm_lead_lost", id: :serial, comment: "Get Lost Reason", force: :cascade do |t|
    t.integer "lost_reason_id", comment: "Lost Reason"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "crm_lead_tag", id: :serial, comment: "Category of lead", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "crm_lead_tag_name_uniq", unique: true
  end

  create_table "crm_lead_tag_rel", id: false, comment: "RELATION BETWEEN crm_lead AND crm_lead_tag", force: :cascade do |t|
    t.integer "lead_id", null: false
    t.integer "tag_id", null: false
    t.index ["lead_id", "tag_id"], name: "crm_lead_tag_rel_lead_id_tag_id_key", unique: true
    t.index ["lead_id"], name: "crm_lead_tag_rel_lead_id_idx"
    t.index ["tag_id"], name: "crm_lead_tag_rel_tag_id_idx"
  end

  create_table "crm_lost_reason", id: :serial, comment: "Reason for loosing leads", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "crm_merge_opportunity", id: :serial, comment: "Merge opportunities", force: :cascade do |t|
    t.integer "user_id", comment: "Salesperson"
    t.integer "team_id", comment: "Sales Channel"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["team_id"], name: "crm_merge_opportunity_team_id_index"
    t.index ["user_id"], name: "crm_merge_opportunity_user_id_index"
  end

  create_table "crm_partner_binding", id: :serial, comment: "Handle partner binding or generation in CRM wizards.", force: :cascade do |t|
    t.string "action", null: false, comment: "Related Customer"
    t.integer "partner_id", comment: "Customer"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "crm_phonecall", id: :serial, comment: "Phonecall", force: :cascade do |t|
    t.datetime "date_action_last", comment: "Last Action"
    t.datetime "date_action_next", comment: "Next Action"
    t.datetime "create_date", comment: "Creation Date"
    t.integer "team_id", comment: "Sales Team"
    t.integer "user_id", comment: "Responsible"
    t.integer "partner_id", comment: "Contact"
    t.integer "company_id", comment: "Company"
    t.text "description", comment: "Description"
    t.string "state", comment: "Status"
    t.string "email_from", comment: "Email"
    t.datetime "date_open", comment: "Opened"
    t.string "name", null: false, comment: "Call Summary"
    t.boolean "active", comment: "Active"
    t.float "duration_moved0", comment: "Duration"
    t.string "partner_phone", comment: "Phone"
    t.string "partner_mobile", comment: "Mobile"
    t.string "priority", comment: "Priority"
    t.datetime "date_closed", comment: "Closed"
    t.datetime "date", comment: "Date"
    t.integer "opportunity_id", comment: "Lead/Opportunity"
    t.integer "campaign_id", comment: "Campaign"
    t.integer "source_id", comment: "Source"
    t.integer "medium_id", comment: "Medium"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "uuid", comment: "Call id"
    t.string "call_direction", comment: "Direction"
    t.string "caller_id_number", comment: "Caller Number"
    t.string "caller_destination", comment: "Caller Destination"
    t.string "origination_callee_id_name", comment: "Origin Callee Number"
    t.string "last_sent_callee_id_number", comment: "Endpoint Number"
    t.string "effective_caller_id_number", comment: "Effective Caller Number"
    t.string "call_result", comment: "Call Status"
    t.datetime "start_epoch", comment: "Start Time"
    t.datetime "end_epoch", comment: "End Time"
    t.datetime "answer_epoch", comment: "Answer Time"
    t.datetime "bridge_epoch", comment: "Bridge Time"
    t.integer "billsec", comment: "Call Duration"
    t.integer "answersec", comment: "Time to Answer"
    t.string "sip_hangup_disposition", comment: "Sip Hangup Disposition"
    t.string "call_record", comment: "Record"
    t.integer "duration", comment: "Total Duration"
    t.index ["team_id"], name: "crm_phonecall_team_id_index"
    t.index ["uuid"], name: "crm_phonecall_uuid_unique", unique: true
  end

  create_table "crm_phonecall2phonecall", id: :serial, comment: "Phonecall To Phonecall", force: :cascade do |t|
    t.string "name", null: false, comment: "Call summary"
    t.integer "user_id", comment: "Assign To"
    t.string "contact_name", comment: "Contact"
    t.string "phone", comment: "Phone"
    t.datetime "date", comment: "Date"
    t.integer "team_id", comment: "Sales Team"
    t.string "action", null: false, comment: "Action"
    t.integer "partner_id", comment: "Partner"
    t.text "note", comment: "Note"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "crm_phonecall2phonecall_name_index"
  end

  create_table "crm_phonecall_tag_rel", id: false, comment: "RELATION BETWEEN crm_phonecall AND crm_lead_tag", force: :cascade do |t|
    t.integer "phone_id", null: false
    t.integer "tag_id", null: false
    t.index ["phone_id", "tag_id"], name: "crm_phonecall_tag_rel_phone_id_tag_id_key", unique: true
    t.index ["phone_id"], name: "crm_phonecall_tag_rel_phone_id_idx"
    t.index ["tag_id"], name: "crm_phonecall_tag_rel_tag_id_idx"
  end

  create_table "crm_stage", id: :serial, comment: "Stage of case", force: :cascade do |t|
    t.string "name", null: false, comment: "Stage Name"
    t.integer "sequence", comment: "Sequence"
    t.float "probability", null: false, comment: "Probability (%)"
    t.boolean "on_change", comment: "Change Probability Automatically"
    t.text "requirements", comment: "Requirements"
    t.integer "team_id", comment: "Team"
    t.text "legend_priority", comment: "Priority Management Explanation"
    t.boolean "fold", comment: "Folded in Pipeline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "crm_team", id: :serial, comment: "Sales Channel", force: :cascade do |t|
    t.string "name", null: false, comment: "Sales Channel"
    t.boolean "active", comment: "Active"
    t.integer "company_id", comment: "Company"
    t.integer "user_id", comment: "Channel Leader"
    t.string "reply_to", comment: "Reply-To"
    t.integer "color", comment: "Color Index"
    t.string "team_type", null: false, comment: "Channel Type"
    t.string "dashboard_graph_model", comment: "Content"
    t.string "dashboard_graph_group", comment: "Group by"
    t.string "dashboard_graph_period", comment: "Scale"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "use_leads", comment: "Leads"
    t.boolean "use_opportunities", comment: "Pipeline"
    t.integer "alias_id", null: false, comment: "Alias"
    t.string "dashboard_graph_group_pipeline", comment: "Group by"
    t.boolean "use_quotations", comment: "Quotations"
    t.boolean "use_invoices", comment: "Set Invoicing Target"
    t.integer "invoiced_target", comment: "Invoicing Target"
    t.integer "marketing_user_id", comment: "Marketing User"
  end

  create_table "crm_team_claim_stage_rel", id: false, comment: "RELATION BETWEEN crm_claim_stage AND crm_team", force: :cascade do |t|
    t.integer "stage_id", null: false
    t.integer "team_id", null: false
    t.index ["stage_id", "team_id"], name: "crm_team_claim_stage_rel_stage_id_team_id_key", unique: true
    t.index ["stage_id"], name: "crm_team_claim_stage_rel_stage_id_idx"
    t.index ["team_id"], name: "crm_team_claim_stage_rel_team_id_idx"
  end

  create_table "decimal_precision", id: :serial, comment: "decimal.precision", force: :cascade do |t|
    t.string "name", null: false, comment: "Usage"
    t.integer "digits", null: false, comment: "Digits"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "decimal_precision_name_index"
    t.index ["name"], name: "decimal_precision_name_uniq", unique: true
  end

  create_table "decimal_precision_test", id: :serial, comment: "decimal.precision.test", force: :cascade do |t|
    t.float "float", comment: "Float"
    t.decimal "float_2", comment: "Float 2"
    t.decimal "float_4", comment: "Float 4"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "document_page", id: :serial, comment: "Document Page", force: :cascade do |t|
    t.string "name", null: false, comment: "Title"
    t.string "type", comment: "Type"
    t.boolean "active", comment: "Active"
    t.integer "parent_id", comment: "Category"
    t.text "template", comment: "Template"
    t.integer "history_head", comment: "HEAD"
    t.integer "menu_id", comment: "Menu"
    t.datetime "content_date", comment: "Last Contribution Date"
    t.integer "content_uid", comment: "Last Contributor"
    t.integer "company_id", comment: "Company"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.datetime "approved_date", comment: "Approved Date"
    t.integer "approved_uid", comment: "Approved by"
    t.boolean "approval_required", comment: "Require approval"
    t.integer "approver_gid", comment: "Approver group"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.index ["approved_date"], name: "document_page_approved_date_index"
    t.index ["approved_uid"], name: "document_page_approved_uid_index"
    t.index ["company_id"], name: "document_page_company_id_index"
    t.index ["content_date"], name: "document_page_content_date_index"
    t.index ["content_uid"], name: "document_page_content_uid_index"
  end

  create_table "document_page_create_menu", id: :serial, comment: "Wizard Create Menu", force: :cascade do |t|
    t.string "menu_name", null: false, comment: "Menu Name"
    t.integer "menu_parent_id", null: false, comment: "Parent Menu"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "document_page_history", id: :serial, comment: "Document Page History", force: :cascade do |t|
    t.integer "page_id", comment: "Page"
    t.string "name", comment: "Name"
    t.string "summary", comment: "Summary"
    t.text "content", comment: "Content"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "state", comment: "Status"
    t.datetime "approved_date", comment: "Approved Date"
    t.integer "approved_uid", comment: "Approved by"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.index ["company_id"], name: "document_page_history_company_id_index"
    t.index ["name"], name: "document_page_history_name_index"
    t.index ["summary"], name: "document_page_history_summary_index"
  end

  create_table "email_template_attachment_rel", id: false, comment: "RELATION BETWEEN mail_template AND ir_attachment", force: :cascade do |t|
    t.integer "email_template_id", null: false
    t.integer "attachment_id", null: false
    t.index ["attachment_id"], name: "email_template_attachment_rel_attachment_id_idx"
    t.index ["email_template_id", "attachment_id"], name: "email_template_attachment_rel_email_template_id_attachment__key", unique: true
    t.index ["email_template_id"], name: "email_template_attachment_rel_email_template_id_idx"
  end

  create_table "email_template_preview", id: :serial, comment: "Email Template Preview", force: :cascade do |t|
    t.string "res_id", comment: "Sample Document"
    t.string "name", comment: "Name"
    t.integer "model_id", comment: "Applies to"
    t.string "model", comment: "Related Document Model"
    t.string "lang", comment: "Language"
    t.boolean "user_signature", comment: "Add Signature"
    t.string "subject", comment: "Subject"
    t.string "email_from", comment: "From"
    t.boolean "use_default_to", comment: "Default recipients"
    t.string "email_to", comment: "To (Emails)"
    t.string "partner_to", comment: "To (Partners)"
    t.string "email_cc", comment: "Cc"
    t.string "reply_to", comment: "Reply-To"
    t.integer "mail_server_id", comment: "Outgoing Mail Server"
    t.text "body_html", comment: "Body"
    t.string "report_name", comment: "Report Filename"
    t.integer "report_template", comment: "Optional report to print and attach"
    t.integer "ref_ir_act_window", comment: "Sidebar action"
    t.boolean "auto_delete", comment: "Auto Delete"
    t.integer "model_object_field", comment: "Field"
    t.integer "sub_object", comment: "Sub-model"
    t.integer "sub_model_object_field", comment: "Sub-field"
    t.string "null_value", comment: "Default Value"
    t.string "copyvalue", comment: "Placeholder Expression"
    t.string "scheduled_date", comment: "Scheduled Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["model"], name: "email_template_preview_model_index"
  end

  create_table "email_template_preview_res_partner_rel", id: false, comment: "RELATION BETWEEN email_template_preview AND res_partner", force: :cascade do |t|
    t.integer "email_template_preview_id", null: false
    t.integer "res_partner_id", null: false
    t.index ["email_template_preview_id", "res_partner_id"], name: "email_template_preview_res_pa_email_template_preview_id_res_key", unique: true
    t.index ["email_template_preview_id"], name: "email_template_preview_res_partne_email_template_preview_id_idx"
    t.index ["res_partner_id"], name: "email_template_preview_res_partner_rel_res_partner_id_idx"
  end

  create_table "employee_category_rel", id: false, comment: "RELATION BETWEEN hr_employee_category AND hr_employee", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "emp_id", null: false
    t.index ["category_id", "emp_id"], name: "employee_category_rel_category_id_emp_id_key", unique: true
    t.index ["category_id"], name: "employee_category_rel_category_id_idx"
    t.index ["emp_id"], name: "employee_category_rel_emp_id_idx"
  end

  create_table "equipment_tag_rel", id: false, comment: "RELATION BETWEEN maintenance_equipment_tag AND maintenance_equipment", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "equipment_id", null: false
    t.index ["equipment_id"], name: "equipment_tag_rel_equipment_id_idx"
    t.index ["tag_id", "equipment_id"], name: "equipment_tag_rel_tag_id_equipment_id_key", unique: true
    t.index ["tag_id"], name: "equipment_tag_rel_tag_id_idx"
  end

  create_table "event_allowed_track_tags_rel", id: false, comment: "RELATION BETWEEN event_event AND event_track_tag", force: :cascade do |t|
    t.integer "event_event_id", null: false
    t.integer "event_track_tag_id", null: false
    t.index ["event_event_id", "event_track_tag_id"], name: "event_allowed_track_tags_rel_event_event_id_event_track_tag_key", unique: true
    t.index ["event_event_id"], name: "event_allowed_track_tags_rel_event_event_id_idx"
    t.index ["event_track_tag_id"], name: "event_allowed_track_tags_rel_event_track_tag_id_idx"
  end

  create_table "event_answer", id: :serial, comment: "event.answer", force: :cascade do |t|
    t.string "name", null: false, comment: "Answer"
    t.integer "question_id", null: false, comment: "Question"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_confirm", id: :serial, comment: "event.confirm", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_event", id: :serial, comment: "Event", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Event Name"
    t.boolean "active", comment: "Active"
    t.integer "user_id", comment: "Responsible"
    t.integer "company_id", comment: "Company"
    t.integer "organizer_id", comment: "Organizer"
    t.integer "event_type_id", comment: "Category"
    t.integer "color", comment: "Kanban Color Index"
    t.integer "seats_max", comment: "Maximum Attendees Number"
    t.string "seats_availability", null: false, comment: "Maximum Attendees"
    t.integer "seats_min", comment: "Minimum Attendees"
    t.integer "seats_reserved", comment: "Reserved Seats"
    t.integer "seats_available", comment: "Available Seats"
    t.integer "seats_unconfirmed", comment: "Unconfirmed Seat Reservations"
    t.integer "seats_used", comment: "Number of Participants"
    t.string "date_tz", null: false, comment: "Timezone"
    t.datetime "date_begin", null: false, comment: "Start Date"
    t.datetime "date_end", null: false, comment: "End Date"
    t.string "state", null: false, comment: "Status"
    t.boolean "auto_confirm", comment: "Autoconfirm Registrations"
    t.boolean "is_online", comment: "Online Event"
    t.integer "address_id", comment: "Location"
    t.integer "country_id", comment: "Country"
    t.string "twitter_hashtag", comment: "Twitter Hashtag"
    t.text "description", comment: "Description"
    t.text "badge_front", comment: "Badge Front"
    t.text "badge_back", comment: "Badge Back"
    t.text "badge_innerleft", comment: "Badge Inner Left"
    t.text "badge_innerright", comment: "Badge Inner Right"
    t.text "event_logo", comment: "Event Logo"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "website_published", comment: "Visible in Website"
    t.boolean "website_menu", comment: "Dedicated Menu"
    t.integer "menu_id", comment: "Event Menu"
    t.string "website_meta_title", comment: "Website meta title"
    t.text "website_meta_description", comment: "Website meta description"
    t.string "website_meta_keywords", comment: "Website meta keywords"
  end

  create_table "event_lead", id: :serial, comment: "event.lead", force: :cascade do |t|
    t.integer "event_id", comment: "Event"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_mail", id: :serial, comment: "Event Automated Mailing", force: :cascade do |t|
    t.integer "event_id", null: false, comment: "Event"
    t.integer "sequence", comment: "Display order"
    t.integer "interval_nbr", comment: "Interval"
    t.string "interval_unit", null: false, comment: "Unit"
    t.string "interval_type", null: false, comment: "Trigger "
    t.integer "template_id", null: false, comment: "Email Template"
    t.datetime "scheduled_date", comment: "Scheduled Sent Mail"
    t.boolean "mail_sent", comment: "Mail Sent on Event"
    t.boolean "done", comment: "Sent"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_mail_registration", id: :serial, comment: "Registration Mail Scheduler", force: :cascade do |t|
    t.integer "scheduler_id", null: false, comment: "Mail Scheduler"
    t.integer "registration_id", null: false, comment: "Attendee"
    t.datetime "scheduled_date", comment: "Scheduled Time"
    t.boolean "mail_sent", comment: "Mail Sent"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_question", id: :serial, comment: "event.question", force: :cascade do |t|
    t.string "title", null: false, comment: "Title"
    t.integer "event_type_id", comment: "Event Type"
    t.integer "event_id", comment: "Event"
    t.integer "sequence", comment: "Sequence"
    t.boolean "is_individual", comment: "Ask each attendee"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_registration", id: :serial, comment: "Attendee", force: :cascade do |t|
    t.string "origin", comment: "Source Document"
    t.integer "event_id", null: false, comment: "Event"
    t.integer "partner_id", comment: "Contact"
    t.datetime "date_open", comment: "Registration Date"
    t.datetime "date_closed", comment: "Attended Date"
    t.integer "company_id", comment: "Company"
    t.string "state", comment: "Status"
    t.string "email", comment: "Email"
    t.string "phone", comment: "Phone"
    t.string "name", comment: "Attendee Name"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "mobile", comment: "Mobile"
    t.text "note", comment: "Note"
    t.integer "user_id", comment: "User"
    t.integer "event_type_id", comment: "Category"
    t.index ["name"], name: "event_registration_name_index"
  end

  create_table "event_registration_answer", id: :serial, comment: "event.registration.answer", force: :cascade do |t|
    t.integer "event_answer_id", null: false, comment: "Event Answer"
    t.integer "event_registration_id", null: false, comment: "Event Registration"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_sponsor", id: :serial, comment: "Event Sponsor", force: :cascade do |t|
    t.integer "event_id", null: false, comment: "Event"
    t.integer "sponsor_type_id", null: false, comment: "Sponsoring Type"
    t.integer "partner_id", null: false, comment: "Sponsor/Customer"
    t.string "url", comment: "Sponsor Website"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_sponsor_type", id: :serial, comment: "Event Sponsor Type", force: :cascade do |t|
    t.string "name", null: false, comment: "Sponsor Type"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_track", id: :serial, comment: "Event Track", force: :cascade do |t|
    t.string "name", null: false, comment: "Title"
    t.boolean "active", comment: "Active"
    t.integer "user_id", comment: "Responsible"
    t.integer "partner_id", comment: "Speaker"
    t.string "partner_name", comment: "Speaker Name"
    t.string "partner_email", comment: "Speaker Email"
    t.string "partner_phone", comment: "Speaker Phone"
    t.text "partner_biography", comment: "Speaker Biography"
    t.integer "stage_id", null: false, comment: "Stage"
    t.string "kanban_state", null: false, comment: "Kanban State"
    t.text "description", comment: "Track Description"
    t.datetime "date", comment: "Track Date"
    t.float "duration", comment: "Duration"
    t.integer "location_id", comment: "Room"
    t.integer "event_id", null: false, comment: "Event"
    t.integer "color", comment: "Color Index"
    t.string "priority", null: false, comment: "Priority"
    t.string "website_meta_title", comment: "Website meta title"
    t.text "website_meta_description", comment: "Website meta description"
    t.string "website_meta_keywords", comment: "Website meta keywords"
    t.boolean "website_published", comment: "Visible in Website"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["stage_id"], name: "event_track_stage_id_index"
  end

  create_table "event_track_event_track_tag_rel", id: false, comment: "RELATION BETWEEN event_track_tag AND event_track", force: :cascade do |t|
    t.integer "event_track_tag_id", null: false
    t.integer "event_track_id", null: false
    t.index ["event_track_id"], name: "event_track_event_track_tag_rel_event_track_id_idx"
    t.index ["event_track_tag_id", "event_track_id"], name: "event_track_event_track_tag_r_event_track_tag_id_event_trac_key", unique: true
    t.index ["event_track_tag_id"], name: "event_track_event_track_tag_rel_event_track_tag_id_idx"
  end

  create_table "event_track_location", id: :serial, comment: "Track Location", force: :cascade do |t|
    t.string "name", comment: "Room"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_track_stage", id: :serial, comment: "Track Stage", force: :cascade do |t|
    t.string "name", null: false, comment: "Stage Name"
    t.integer "sequence", comment: "Sequence"
    t.integer "mail_template_id", comment: "Email Template"
    t.boolean "fold", comment: "Folded in Kanban"
    t.boolean "is_done", comment: "Accepted Stage"
    t.boolean "is_cancel", comment: "Canceled Stage"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "event_track_tag", id: :serial, comment: "Track Tag", force: :cascade do |t|
    t.string "name", comment: "Tag"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "event_track_tag_name_uniq", unique: true
  end

  create_table "event_track_tags_rel", id: false, comment: "RELATION BETWEEN event_event AND event_track_tag", force: :cascade do |t|
    t.integer "event_event_id", null: false
    t.integer "event_track_tag_id", null: false
    t.index ["event_event_id", "event_track_tag_id"], name: "event_track_tags_rel_event_event_id_event_track_tag_id_key", unique: true
    t.index ["event_event_id"], name: "event_track_tags_rel_event_event_id_idx"
    t.index ["event_track_tag_id"], name: "event_track_tags_rel_event_track_tag_id_idx"
  end

  create_table "event_type", id: :serial, comment: "Event Category", force: :cascade do |t|
    t.string "name", null: false, comment: "Event Category"
    t.boolean "has_seats_limitation", comment: "Limited Seats"
    t.integer "default_registration_min", comment: "Minimum Registrations"
    t.integer "default_registration_max", comment: "Maximum Registrations"
    t.boolean "auto_confirm", comment: "Automatically Confirm Registrations"
    t.boolean "is_online", comment: "Online Event"
    t.boolean "use_timezone", comment: "Use Default Timezone"
    t.string "default_timezone", comment: "Timezone"
    t.boolean "use_hashtag", comment: "Use Default Hashtag"
    t.string "default_hashtag", comment: "Twitter Hashtag"
    t.boolean "use_mail_schedule", comment: "Automatically Send Emails"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "website_menu", comment: "Display a dedicated menu on Website"
    t.boolean "use_questions", comment: "Questions to Attendees"
    t.boolean "website_track", comment: "Tracks on Website"
    t.boolean "website_track_proposal", comment: "Tracks Proposals on Website"
  end

  create_table "event_type_mail", id: :serial, comment: "Mail Scheduling on Event Type", force: :cascade do |t|
    t.integer "event_type_id", null: false, comment: "Event Type"
    t.integer "interval_nbr", comment: "Interval"
    t.string "interval_unit", null: false, comment: "Unit"
    t.string "interval_type", null: false, comment: "Trigger"
    t.integer "template_id", null: false, comment: "Email Template"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "expense_tax", id: false, comment: "RELATION BETWEEN hr_expense AND account_tax", force: :cascade do |t|
    t.integer "expense_id", null: false
    t.integer "tax_id", null: false
    t.index ["expense_id", "tax_id"], name: "expense_tax_expense_id_tax_id_key", unique: true
    t.index ["expense_id"], name: "expense_tax_expense_id_idx"
    t.index ["tax_id"], name: "expense_tax_tax_id_idx"
  end

  create_table "export_attendance", id: :serial, comment: "export.attendance", force: :cascade do |t|
    t.date "to_date", comment: "To Date"
    t.date "from_date", comment: "From Date"
    t.integer "year_id", comment: "Year"
    t.string "month", comment: "Month"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "employee_type", comment: "Employee Type"
  end

  create_table "fees_detail_report_wizard", id: :serial, comment: "fees.detail.report.wizard", force: :cascade do |t|
    t.string "fees_filter", null: false, comment: "Fees Filter"
    t.integer "student_id", comment: "Student"
    t.integer "course_id", comment: "Course"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "fetchmail_server", id: :serial, comment: "POP/IMAP Server", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.boolean "active", comment: "Active"
    t.string "state", comment: "Status"
    t.string "server", comment: "Server Name"
    t.integer "port", comment: "Port"
    t.string "type", null: false, comment: "Server Type"
    t.boolean "is_ssl", comment: "SSL/TLS"
    t.boolean "attach", comment: "Keep Attachments"
    t.boolean "original", comment: "Keep Original"
    t.datetime "date", comment: "Last Fetch Date"
    t.string "user", comment: "Username"
    t.string "password", comment: "Password"
    t.integer "action_id", comment: "Server Action"
    t.integer "object_id", comment: "Create a New Record"
    t.integer "priority", comment: "Server Priority"
    t.text "configuration", comment: "Configuration"
    t.string "script", comment: "Script"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["state"], name: "fetchmail_server_state_index"
    t.index ["type"], name: "fetchmail_server_type_index"
  end

  create_table "gamification_badge", id: :serial, comment: "Gamification badge", force: :cascade do |t|
    t.string "name", null: false, comment: "Badge"
    t.boolean "active", comment: "Active"
    t.text "description", comment: "Description"
    t.string "rule_auth", null: false, comment: "Allowance to Grant"
    t.boolean "rule_max", comment: "Monthly Limited Sending"
    t.integer "rule_max_number", comment: "Limitation Number"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "gamification_badge_rule_badge_rel", id: false, comment: "RELATION BETWEEN gamification_badge AND gamification_badge", force: :cascade do |t|
    t.integer "badge1_id", null: false
    t.integer "badge2_id", null: false
    t.index ["badge1_id", "badge2_id"], name: "gamification_badge_rule_badge_rel_badge1_id_badge2_id_key", unique: true
    t.index ["badge1_id"], name: "gamification_badge_rule_badge_rel_badge1_id_idx"
    t.index ["badge2_id"], name: "gamification_badge_rule_badge_rel_badge2_id_idx"
  end

  create_table "gamification_badge_user", id: :serial, comment: "Gamification user badge", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "User"
    t.integer "sender_id", comment: "Sender"
    t.integer "badge_id", null: false, comment: "Badge"
    t.integer "challenge_id", comment: "Challenge originating"
    t.text "comment", comment: "Comment"
    t.datetime "create_date", comment: "Created"
    t.integer "create_uid", comment: "Creator"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "employee_id", comment: "Employee"
    t.index ["badge_id"], name: "gamification_badge_user_badge_id_index"
    t.index ["user_id"], name: "gamification_badge_user_user_id_index"
  end

  create_table "gamification_badge_user_wizard", id: :serial, comment: "gamification.badge.user.wizard", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "User"
    t.integer "badge_id", null: false, comment: "Badge"
    t.text "comment", comment: "Comment"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "employee_id", null: false, comment: "Employee"
  end

  create_table "gamification_challenge", id: :serial, comment: "Gamification challenge", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Challenge Name"
    t.text "description", comment: "Description"
    t.string "state", null: false, comment: "State"
    t.integer "manager_id", comment: "Responsible"
    t.string "user_domain", comment: "User domain"
    t.string "period", null: false, comment: "Periodicity"
    t.date "start_date", comment: "Start Date"
    t.date "end_date", comment: "End Date"
    t.integer "reward_id", comment: "For Every Succeeding User"
    t.integer "reward_first_id", comment: "For 1st user"
    t.integer "reward_second_id", comment: "For 2nd user"
    t.integer "reward_third_id", comment: "For 3rd user"
    t.boolean "reward_failure", comment: "Reward Bests if not Succeeded?"
    t.boolean "reward_realtime", comment: "Reward as soon as every goal is reached"
    t.string "visibility_mode", null: false, comment: "Display Mode"
    t.string "report_message_frequency", null: false, comment: "Report Frequency"
    t.integer "report_message_group_id", comment: "Send a copy to"
    t.integer "report_template_id", null: false, comment: "Report Template"
    t.integer "remind_update_delay", comment: "Non-updated manual goals will be reminded after"
    t.date "last_report_date", comment: "Last Report Date"
    t.date "next_report_date", comment: "Next Report Date"
    t.string "category", null: false, comment: "Appears in"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "gamification_challenge_line", id: :serial, comment: "Gamification generic goal for challenge", force: :cascade do |t|
    t.integer "challenge_id", null: false, comment: "Challenge"
    t.integer "definition_id", null: false, comment: "Goal Definition"
    t.integer "sequence", comment: "Sequence"
    t.float "target_goal", null: false, comment: "Target Value to Reach"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "gamification_challenge_users_rel", id: false, comment: "RELATION BETWEEN gamification_challenge AND res_users", force: :cascade do |t|
    t.integer "gamification_challenge_id", null: false
    t.integer "res_users_id", null: false
    t.index ["gamification_challenge_id", "res_users_id"], name: "gamification_challenge_users__gamification_challenge_id_res_key", unique: true
    t.index ["gamification_challenge_id"], name: "gamification_challenge_users_rel_gamification_challenge_id_idx"
    t.index ["res_users_id"], name: "gamification_challenge_users_rel_res_users_id_idx"
  end

  create_table "gamification_goal", id: :serial, comment: "Gamification goal instance", force: :cascade do |t|
    t.integer "definition_id", null: false, comment: "Goal Definition"
    t.integer "user_id", null: false, comment: "User"
    t.integer "line_id", comment: "Challenge Line"
    t.integer "challenge_id", comment: "Challenge"
    t.date "start_date", comment: "Start Date"
    t.date "end_date", comment: "End Date"
    t.float "target_goal", null: false, comment: "To Reach"
    t.float "current", null: false, comment: "Current Value"
    t.string "state", null: false, comment: "State"
    t.boolean "to_update", comment: "To update"
    t.boolean "closed", comment: "Closed goal"
    t.integer "remind_update_delay", comment: "Remind delay"
    t.date "last_update", comment: "Last Update"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "gamification_goal_definition", id: :serial, comment: "Gamification goal definition", force: :cascade do |t|
    t.string "name", null: false, comment: "Goal Definition"
    t.text "description", comment: "Goal Description"
    t.boolean "monetary", comment: "Monetary Value"
    t.string "suffix", comment: "Suffix"
    t.string "computation_mode", null: false, comment: "Computation Mode"
    t.string "display_mode", null: false, comment: "Displayed as"
    t.integer "model_id", comment: "Model"
    t.integer "field_id", comment: "Field to Sum"
    t.integer "field_date_id", comment: "Date Field"
    t.string "domain", null: false, comment: "Filter Domain"
    t.boolean "batch_mode", comment: "Batch Mode"
    t.integer "batch_distinctive_field", comment: "Distinctive field for batch user"
    t.string "batch_user_expression", comment: "Evaluated expression for batch mode"
    t.text "compute_code", comment: "Python Code"
    t.string "condition", null: false, comment: "Goal Performance"
    t.integer "action_id", comment: "Action"
    t.string "res_id_field", comment: "ID Field of user"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "gamification_goal_wizard", id: :serial, comment: "gamification.goal.wizard", force: :cascade do |t|
    t.integer "goal_id", null: false, comment: "Goal"
    t.float "current", comment: "Current"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "gamification_invited_user_ids_rel", id: false, comment: "RELATION BETWEEN gamification_challenge AND res_users", force: :cascade do |t|
    t.integer "gamification_challenge_id", null: false
    t.integer "res_users_id", null: false
    t.index ["gamification_challenge_id", "res_users_id"], name: "gamification_invited_user_ids_gamification_challenge_id_res_key", unique: true
    t.index ["gamification_challenge_id"], name: "gamification_invited_user_ids_rel_gamification_challenge_id_idx"
    t.index ["res_users_id"], name: "gamification_invited_user_ids_rel_res_users_id_idx"
  end

  create_table "gen_time_table_line", id: :serial, comment: "Generate Time Table Lines", force: :cascade do |t|
    t.integer "gen_time_table", null: false, comment: "Time Table"
    t.integer "faculty_id", null: false, comment: "Faculty"
    t.integer "subject_id", comment: "Subject"
    t.integer "timing_id", null: false, comment: "Timing"
    t.integer "classroom_id", comment: "Classroom"
    t.string "day", null: false, comment: "Day"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "generate_time_table", id: :serial, comment: "Generate Sessions", force: :cascade do |t|
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.date "start_date", null: false, comment: "Start Date"
    t.date "end_date", comment: "End Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "subject_id", comment: "Subject"
  end

  create_table "google_drive_config", id: :serial, comment: "Google Drive templates config", force: :cascade do |t|
    t.string "name", null: false, comment: "Template Name"
    t.integer "model_id", null: false, comment: "Model"
    t.integer "filter_id", comment: "Filter"
    t.string "google_drive_template_url", null: false, comment: "Template URL"
    t.string "name_template", null: false, comment: "Google Drive Name Pattern"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "google_service", id: :serial, comment: "google.service", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_applicant", id: :serial, comment: "Applicant", force: :cascade do |t|
    t.string "name", null: false, comment: "Subject / Application Name"
    t.boolean "active", comment: "Active"
    t.text "description", comment: "Description"
    t.string "email_from", limit: 128, comment: "Email"
    t.text "email_cc", comment: "Watchers Emails"
    t.float "probability", comment: "Probability"
    t.integer "partner_id", comment: "Contact"
    t.datetime "create_date", comment: "Creation Date"
    t.datetime "write_date", comment: "Update Date"
    t.integer "stage_id", comment: "Stage"
    t.integer "last_stage_id", comment: "Last Stage"
    t.integer "company_id", comment: "Company"
    t.integer "user_id", comment: "Responsible"
    t.datetime "date_closed", comment: "Closed"
    t.datetime "date_open", comment: "Assigned"
    t.datetime "date_last_stage_update", comment: "Last Stage Update"
    t.string "priority", comment: "Appreciation"
    t.integer "job_id", comment: "Applied Job"
    t.string "salary_proposed_extra", comment: "Proposed Salary Extra"
    t.string "salary_expected_extra", comment: "Expected Salary Extra"
    t.float "salary_proposed", comment: "Proposed Salary"
    t.float "salary_expected", comment: "Expected Salary"
    t.date "availability", comment: "Availability"
    t.string "partner_name", comment: "Applicant's Name"
    t.string "partner_phone", limit: 32, comment: "Phone"
    t.string "partner_mobile", limit: 32, comment: "Mobile"
    t.integer "type_id", comment: "Degree"
    t.integer "department_id", comment: "Department"
    t.string "reference", comment: "Referred By"
    t.float "delay_close", comment: "Delay to Close"
    t.integer "color", comment: "Color Index"
    t.integer "emp_id", comment: "Employee"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "campaign_id", comment: "Campaign"
    t.integer "source_id", comment: "Source"
    t.integer "medium_id", comment: "Medium"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.integer "applicant_source_id", comment: "Source"
    t.integer "source_applicant_id", comment: "Source Applicant"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.integer "incomming_email_id", comment: "Incomming email"
    t.index ["create_date"], name: "hr_applicant_create_date_index"
    t.index ["date_closed"], name: "hr_applicant_date_closed_index"
    t.index ["date_last_stage_update"], name: "hr_applicant_date_last_stage_update_index"
    t.index ["date_open"], name: "hr_applicant_date_open_index"
    t.index ["email_from", "partner_phone", "partner_mobile"], name: "hr_applicant_email_phone_uniq", unique: true
    t.index ["stage_id"], name: "hr_applicant_stage_id_index"
  end

  create_table "hr_applicant_category", id: :serial, comment: "Category of applicant", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "hr_applicant_category_name_uniq", unique: true
  end

  create_table "hr_applicant_hr_applicant_category_rel", id: false, comment: "RELATION BETWEEN hr_applicant AND hr_applicant_category", force: :cascade do |t|
    t.integer "hr_applicant_id", null: false
    t.integer "hr_applicant_category_id", null: false
    t.index ["hr_applicant_category_id"], name: "hr_applicant_hr_applicant_category_hr_applicant_category_id_idx"
    t.index ["hr_applicant_id", "hr_applicant_category_id"], name: "hr_applicant_hr_applicant_cat_hr_applicant_id_hr_applicant__key", unique: true
    t.index ["hr_applicant_id"], name: "hr_applicant_hr_applicant_category_rel_hr_applicant_id_idx"
  end

  create_table "hr_attendance", id: :serial, comment: "Attendance", force: :cascade do |t|
    t.integer "employee_id", null: false, comment: "Employee"
    t.datetime "check_in", null: false, comment: "Check In"
    t.datetime "check_out", comment: "Check Out"
    t.float "worked_hours", comment: "Worked Hours"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "overtime_created", comment: "Overtime Created"
    t.integer "late_in", comment: "Late In"
    t.integer "early_out", comment: "Early Out"
    t.date "date_cr", comment: "Date Cr"
    t.date "attendance_date", comment: "Attendance Date"
    t.integer "company_id", comment: "Company"
    t.string "shift_work", comment: "Phân loại nhân viên"
    t.string "day_of_week", comment: "Day of Week"
    t.float "day_work", comment: "WorkDay"
    t.float "work_day", comment: "WorkDay"
    t.float "work_of_day", comment: "WorkDay"
    t.integer "holiday_id", comment: "Leave"
    t.string "holiday_state", comment: "Holiday State"
    t.float "total_workday", comment: "Work Total"
    t.float "total_work", comment: "Work Total"
    t.float "hours_ctv", comment: "Working Hours"
    t.integer "holiday_hours", comment: "Holiday Hours"
    t.index ["employee_id"], name: "hr_attendance_employee_id_index"
  end

  create_table "hr_attendance_addition", id: :serial, comment: "hr.attendance.addition", force: :cascade do |t|
    t.integer "employee_id", comment: "Employee"
    t.string "desc", comment: "Description"
    t.datetime "checkin", comment: "Checkin"
    t.datetime "checkout", comment: "Checkout"
    t.integer "department_id", comment: "Department"
    t.string "note", comment: "Note"
    t.integer "type", comment: "Type"
    t.string "state", comment: "State"
    t.date "date", comment: "Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_attendance_import", id: :serial, comment: "hr.attendance.import", force: :cascade do |t|
    t.integer "attachment_id", null: false, comment: "Danh sách ra vào"
    t.string "error_log", comment: "Error Log"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_attendance_report", id: :serial, comment: "Report Attendance", force: :cascade do |t|
    t.date "start_date", null: false, comment: "Từ ngày"
    t.date "end_date", comment: "Tới ngày"
    t.integer "company_id", null: false, comment: "Công ty"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_contract", id: :serial, comment: "Contract", force: :cascade do |t|
    t.string "name", null: false, comment: "Contract Reference"
    t.integer "employee_id", comment: "Employee"
    t.integer "department_id", comment: "Department"
    t.integer "type_id", null: false, comment: "Contract Type"
    t.integer "job_id", comment: "Job Position"
    t.date "date_start", null: false, comment: "Start Date"
    t.date "date_end", comment: "End Date"
    t.date "trial_date_end", comment: "End of Trial Period"
    t.integer "resource_calendar_id", null: false, comment: "Working Schedule"
    t.decimal "wage", null: false, comment: "Wage"
    t.text "advantages", comment: "Advantages"
    t.text "notes", comment: "Notes"
    t.string "state", comment: "Status"
    t.integer "company_id", comment: "Company"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "struct_id", comment: "Salary Structure"
    t.string "schedule_pay", comment: "Scheduled Pay"
    t.float "work_hours", comment: "Working Hours"
    t.index ["schedule_pay"], name: "hr_contract_schedule_pay_index"
  end

  create_table "hr_contract_advantage_template", id: :serial, comment: "Employee's Advantage on Contract", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.float "lower_bound", comment: "Lower Bound"
    t.float "upper_bound", comment: "Upper Bound"
    t.float "default_value", comment: "Default value for this advantage"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_contract_type", id: :serial, comment: "Contract Type", force: :cascade do |t|
    t.string "name", null: false, comment: "Contract Type"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_contribution_register", id: :serial, comment: "Contribution Register", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.integer "partner_id", comment: "Partner"
    t.string "name", null: false, comment: "Name"
    t.text "note", comment: "Description"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_department", id: :serial, comment: "HR Department", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Department Name"
    t.string "complete_name", comment: "Complete Name"
    t.boolean "active", comment: "Active"
    t.integer "company_id", comment: "Company"
    t.integer "parent_id", comment: "Parent Department"
    t.integer "manager_id", comment: "Manager"
    t.text "note", comment: "Note"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["company_id"], name: "hr_department_company_id_index"
    t.index ["parent_id"], name: "hr_department_parent_id_index"
  end

  create_table "hr_employee", id: :serial, comment: "Employee", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Name"
    t.boolean "active", comment: "Active"
    t.integer "address_home_id", comment: "Private Address"
    t.integer "country_id", comment: "Nationality (Country)"
    t.string "gender", comment: "Gender"
    t.string "marital", comment: "Marital Status"
    t.date "birthday", comment: "Date of Birth"
    t.string "ssnid", comment: "SSN No"
    t.string "sinid", comment: "SIN No"
    t.string "identification_id", comment: "Identification No"
    t.string "passport_id", comment: "Passport No"
    t.integer "bank_account_id", comment: "Bank Account Number"
    t.string "permit_no", comment: "Work Permit No"
    t.string "visa_no", comment: "Visa No"
    t.date "visa_expire", comment: "Visa Expire Date"
    t.integer "address_id", comment: "Work Address"
    t.string "work_phone", comment: "Work Phone"
    t.string "mobile_phone", comment: "Work Mobile"
    t.string "work_email", comment: "Work Email"
    t.string "work_location", comment: "Work Location"
    t.integer "job_id", comment: "Job Position"
    t.integer "department_id", comment: "Department"
    t.integer "parent_id", comment: "Manager"
    t.integer "coach_id", comment: "Coach"
    t.text "notes", comment: "Notes"
    t.integer "color", comment: "Color Index"
    t.integer "resource_id", null: false, comment: "Resource"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "barcode", comment: "Badge ID"
    t.string "pin", comment: "PIN"
    t.boolean "manager", comment: "Is a Manager"
    t.date "medic_exam", comment: "Medical Examination Date"
    t.string "place_of_birth", comment: "Place of Birth"
    t.integer "children", comment: "Number of Children"
    t.string "vehicle", comment: "Company Vehicle"
    t.integer "vehicle_distance", comment: "Home-Work Dist."
    t.date "start_date", comment: "Ngày bắt đầu làm việc"
    t.date "end_date", comment: "Ngày kết thúc làm việc"
    t.string "state", comment: "Trạng thái"
    t.string "contract_time", comment: "Thời gian hợp đồng"
    t.integer "device_code", comment: "Code in device"
    t.boolean "shift_doing", comment: "Do shift"
    t.boolean "already_employee", comment: "Already Employee"
    t.string "presenter", comment: "Người giới thiệu"
    t.integer "presenter_employee", comment: "Presenter"
    t.date "presenter_date", comment: "Ngày giới thiệu"
    t.string "ngach", comment: "Ngạch"
    t.float "he_so", comment: "Hệ số"
    t.integer "bac", comment: "Bậc"
    t.string "shift_work", comment: "Khối"
    t.float "leaves_day", comment: "Ngày nghỉ phép còn lại"
    t.integer "id_employee", comment: "ID Employee"
    t.decimal "timesheet_cost", comment: "Timesheet Cost"
    t.string "shift_work_do", comment: "Phân loại nhân viên"
    t.integer "contract_id", comment: "Current Contract"
    t.string "contract_state", comment: "Status"
    t.string "employee_code", comment: "Employee Code"
    t.index ["barcode"], name: "hr_employee_barcode_uniq", unique: true
    t.index ["company_id"], name: "hr_employee_company_id_index"
    t.index ["resource_id"], name: "hr_employee_resource_id_index"
  end

  create_table "hr_employee_category", id: :serial, comment: "Employee Category", force: :cascade do |t|
    t.string "name", null: false, comment: "Employee Tag"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "hr_employee_category_name_uniq", unique: true
  end

  create_table "hr_employee_group_rel", id: false, comment: "RELATION BETWEEN hr_payslip_employees AND hr_employee", force: :cascade do |t|
    t.integer "payslip_id", null: false
    t.integer "employee_id", null: false
    t.index ["employee_id"], name: "hr_employee_group_rel_employee_id_idx"
    t.index ["payslip_id", "employee_id"], name: "hr_employee_group_rel_payslip_id_employee_id_key", unique: true
    t.index ["payslip_id"], name: "hr_employee_group_rel_payslip_id_idx"
  end

  create_table "hr_expense", id: :serial, comment: "Expense", force: :cascade do |t|
    t.string "name", null: false, comment: "Expense Description"
    t.date "date", comment: "Expense Date"
    t.integer "employee_id", null: false, comment: "Employee"
    t.integer "product_id", null: false, comment: "Product"
    t.integer "product_uom_id", null: false, comment: "Unit of Measure"
    t.decimal "unit_amount", null: false, comment: "Unit Price"
    t.decimal "quantity", null: false, comment: "Quantity"
    t.decimal "untaxed_amount", comment: "Subtotal"
    t.decimal "total_amount", comment: "Total"
    t.integer "company_id", comment: "Company"
    t.integer "currency_id", comment: "Currency"
    t.integer "analytic_account_id", comment: "Analytic Account"
    t.integer "account_id", comment: "Account"
    t.text "description", comment: "Description"
    t.string "payment_mode", comment: "Payment By"
    t.string "state", comment: "Status"
    t.integer "sheet_id", comment: "Expense Report"
    t.string "reference", comment: "Bill Reference"
    t.boolean "is_refused", comment: "Explicitely Refused by manager or acccountant"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "sale_order_id", comment: "Sale Order"
    t.integer "manager_id", comment: "Manager"
    t.integer "claim_id", comment: "Claim"
    t.index ["state"], name: "hr_expense_state_index"
  end

  create_table "hr_expense_hr_expense_refuse_wizard_rel", id: false, comment: "RELATION BETWEEN hr_expense_refuse_wizard AND hr_expense", force: :cascade do |t|
    t.integer "hr_expense_refuse_wizard_id", null: false
    t.integer "hr_expense_id", null: false
    t.index ["hr_expense_id"], name: "hr_expense_hr_expense_refuse_wizard_rel_hr_expense_id_idx"
    t.index ["hr_expense_refuse_wizard_id", "hr_expense_id"], name: "hr_expense_hr_expense_refuse__hr_expense_refuse_wizard_id_h_key", unique: true
    t.index ["hr_expense_refuse_wizard_id"], name: "hr_expense_hr_expense_refuse_wi_hr_expense_refuse_wizard_id_idx"
  end

  create_table "hr_expense_refuse_wizard", id: :serial, comment: "Expense refuse Reason wizard", force: :cascade do |t|
    t.string "reason", null: false, comment: "Reason"
    t.integer "hr_expense_sheet_id", comment: "Hr Expense Sheet"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_expense_sheet", id: :serial, comment: "Expense Report", force: :cascade do |t|
    t.string "name", null: false, comment: "Expense Report Summary"
    t.string "state", null: false, comment: "Status"
    t.integer "employee_id", null: false, comment: "Employee"
    t.integer "address_id", comment: "Employee Home Address"
    t.integer "responsible_id", comment: "Validation By"
    t.decimal "total_amount", comment: "Total Amount"
    t.integer "company_id", comment: "Company"
    t.integer "currency_id", comment: "Currency"
    t.integer "journal_id", comment: "Expense Journal"
    t.integer "bank_journal_id", comment: "Bank Journal"
    t.date "accounting_date", comment: "Date"
    t.integer "account_move_id", comment: "Journal Entry"
    t.integer "department_id", comment: "Department"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "active", comment: "Active"
    t.index ["state"], name: "hr_expense_sheet_state_index"
  end

  create_table "hr_expense_sheet_register_payment_wizard", id: :serial, comment: "Expense Report Register Payment wizard", force: :cascade do |t|
    t.integer "partner_id", null: false, comment: "Partner"
    t.integer "journal_id", null: false, comment: "Payment Method"
    t.integer "payment_method_id", null: false, comment: "Payment Type"
    t.decimal "amount", null: false, comment: "Payment Amount"
    t.integer "currency_id", null: false, comment: "Currency"
    t.date "payment_date", null: false, comment: "Payment Date"
    t.string "communication", comment: "Memo"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_holidays", id: :serial, comment: "Leave", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Description"
    t.string "state", comment: "Status"
    t.boolean "payslip_status", comment: "Reported in last payslips"
    t.text "report_note", comment: "HR Comments"
    t.integer "user_id", comment: "User"
    t.datetime "date_from", comment: "Start Date"
    t.datetime "date_to", comment: "End Date"
    t.integer "holiday_status_id", null: false, comment: "Leave Type"
    t.integer "employee_id", comment: "Employee"
    t.integer "manager_id", comment: "Manager"
    t.text "notes", comment: "Reasons"
    t.float "number_of_days_temp", comment: "Allocation"
    t.float "number_of_days", comment: "Number of Days"
    t.integer "meeting_id", comment: "Meeting"
    t.string "type", null: false, comment: "Request Type"
    t.integer "parent_id", comment: "Parent"
    t.integer "department_id", comment: "Department"
    t.integer "category_id", comment: "Employee Tag"
    t.string "holiday_type", null: false, comment: "Allocation Mode"
    t.integer "first_approver_id", comment: "First Approval"
    t.integer "second_approver_id", comment: "Second Approval"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "company_id", comment: "Company"
    t.datetime "date_from_cp", comment: "Date From Cp"
    t.datetime "date_to_cp", comment: "Date To Cp"
    t.date "date_cr", comment: "Date Cr"
    t.date "holiday_date", comment: "Holiday date"
    t.integer "hours", comment: "Hours"
    t.string "status", comment: "Status Type"
    t.boolean "many_day", comment: "Multiple day"
    t.float "number_of_many_day", comment: "Số ngày nghỉ nhiều"
    t.string "shift_work_do", comment: "Phân loại nhân viên"
    t.string "hcns_bgd", comment: "HCNS/BGĐ xác nhận"
    t.text "hcns_bgd_note", comment: "Lý do của HCNS/BGĐ"
    t.index ["date_from"], name: "hr_holidays_date_from_index"
    t.index ["employee_id"], name: "hr_holidays_employee_id_index"
    t.index ["type"], name: "hr_holidays_type_index"
  end

  create_table "hr_holidays_status", id: :serial, comment: "Leave Type", force: :cascade do |t|
    t.string "name", null: false, comment: "Leave Type"
    t.integer "categ_id", comment: "Meeting Type"
    t.string "color_name", null: false, comment: "Color in Report"
    t.boolean "limit", comment: "Allow to Override Limit"
    t.boolean "active", comment: "Active"
    t.boolean "double_validation", comment: "Apply Double Validation"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "timesheet_generate", comment: "Generate Timesheet"
    t.integer "timesheet_project_id", comment: "Internal Project"
    t.integer "timesheet_task_id", comment: "Internal Task for timesheet"
    t.string "status", comment: "Status Type"
  end

  create_table "hr_holidays_summary_dept", id: :serial, comment: "HR Leaves Summary Report By Department", force: :cascade do |t|
    t.date "date_from", null: false, comment: "From"
    t.string "holiday_type", null: false, comment: "Leave Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_holidays_summary_employee", id: :serial, comment: "HR Leaves Summary Report By Employee", force: :cascade do |t|
    t.date "date_from", null: false, comment: "From"
    t.string "holiday_type", null: false, comment: "Select Leave Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_job", id: :serial, comment: "Job Position", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Job Position"
    t.integer "expected_employees", comment: "Total Forecasted Employees"
    t.integer "no_of_employee", comment: "Current Number of Employees"
    t.integer "no_of_recruitment", comment: "Expected New Employees"
    t.integer "no_of_hired_employee", comment: "Hired Employees"
    t.text "description", comment: "Job Description"
    t.text "requirements", comment: "Requirements"
    t.integer "department_id", comment: "Department"
    t.integer "company_id", comment: "Company"
    t.string "state", null: false, comment: "Status"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "address_id", comment: "Job Location"
    t.integer "manager_id", comment: "Department Manager"
    t.integer "user_id", comment: "Recruitment Responsible"
    t.integer "hr_responsible_id", comment: "HR Responsible"
    t.integer "alias_id", null: false, comment: "Alias"
    t.integer "color", comment: "Color Index"
    t.text "website_description", comment: "Website description"
    t.string "website_meta_title", comment: "Website meta title"
    t.text "website_meta_description", comment: "Website meta description"
    t.string "website_meta_keywords", comment: "Website meta keywords"
    t.boolean "website_published", comment: "Visible in Website"
    t.index ["name", "company_id", "department_id"], name: "hr_job_name_company_uniq", unique: true
    t.index ["name"], name: "hr_job_name_index"
  end

  create_table "hr_payroll_structure", id: :serial, comment: "Salary Structure", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Reference"
    t.integer "company_id", null: false, comment: "Company"
    t.text "note", comment: "Description"
    t.integer "parent_id", comment: "Parent"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_payslip", id: :serial, comment: "Pay Slip", force: :cascade do |t|
    t.integer "struct_id", comment: "Structure"
    t.string "name", comment: "Payslip Name"
    t.string "number", comment: "Reference"
    t.integer "employee_id", null: false, comment: "Employee"
    t.date "date_from", null: false, comment: "Date From"
    t.date "date_to", null: false, comment: "Date To"
    t.string "state", comment: "Status"
    t.integer "company_id", comment: "Company"
    t.boolean "paid", comment: "Made Payment Order ? "
    t.text "note", comment: "Internal Note"
    t.integer "contract_id", comment: "Contract"
    t.boolean "credit_note", comment: "Credit Note"
    t.integer "payslip_run_id", comment: "Payslip Batches"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["state"], name: "hr_payslip_state_index"
  end

  create_table "hr_payslip_employees", id: :serial, comment: "Generate payslips for all selected employees", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_payslip_input", id: :serial, comment: "Payslip Input", force: :cascade do |t|
    t.string "name", null: false, comment: "Description"
    t.integer "payslip_id", null: false, comment: "Pay Slip"
    t.integer "sequence", null: false, comment: "Sequence"
    t.string "code", null: false, comment: "Code"
    t.float "amount", comment: "Amount"
    t.integer "contract_id", null: false, comment: "Contract"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["payslip_id"], name: "hr_payslip_input_payslip_id_index"
    t.index ["sequence"], name: "hr_payslip_input_sequence_index"
  end

  create_table "hr_payslip_line", id: :serial, comment: "Payslip Line", force: :cascade do |t|
    t.integer "slip_id", null: false, comment: "Pay Slip"
    t.integer "salary_rule_id", null: false, comment: "Rule"
    t.integer "employee_id", null: false, comment: "Employee"
    t.integer "contract_id", null: false, comment: "Contract"
    t.decimal "rate", comment: "Rate (%)"
    t.decimal "amount", comment: "Amount"
    t.decimal "quantity", comment: "Quantity"
    t.decimal "total", comment: "Total"
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "sequence", null: false, comment: "Sequence"
    t.integer "category_id", null: false, comment: "Category"
    t.boolean "active", comment: "Active"
    t.boolean "appears_on_payslip", comment: "Appears on Payslip"
    t.integer "parent_rule_id", comment: "Parent Salary Rule"
    t.integer "company_id", comment: "Company"
    t.string "condition_select", null: false, comment: "Condition Based on"
    t.string "condition_range", comment: "Range Based on"
    t.text "condition_python", null: false, comment: "Python Condition"
    t.float "condition_range_min", comment: "Minimum Range"
    t.float "condition_range_max", comment: "Maximum Range"
    t.string "amount_select", null: false, comment: "Amount Type"
    t.decimal "amount_fix", comment: "Fixed Amount"
    t.decimal "amount_percentage", comment: "Percentage (%)"
    t.text "amount_python_compute", comment: "Python Code"
    t.string "amount_percentage_base", comment: "Percentage based on"
    t.integer "register_id", comment: "Contribution Register"
    t.text "note", comment: "Description"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["amount_select"], name: "hr_payslip_line_amount_select_index"
    t.index ["contract_id"], name: "hr_payslip_line_contract_id_index"
    t.index ["parent_rule_id"], name: "hr_payslip_line_parent_rule_id_index"
    t.index ["sequence"], name: "hr_payslip_line_sequence_index"
  end

  create_table "hr_payslip_run", id: :serial, comment: "Payslip Batches", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "state", comment: "Status"
    t.date "date_start", null: false, comment: "Date From"
    t.date "date_end", null: false, comment: "Date To"
    t.boolean "credit_note", comment: "Credit Note"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["state"], name: "hr_payslip_run_state_index"
  end

  create_table "hr_payslip_worked_days", id: :serial, comment: "Payslip Worked Days", force: :cascade do |t|
    t.string "name", null: false, comment: "Description"
    t.integer "payslip_id", null: false, comment: "Pay Slip"
    t.integer "sequence", null: false, comment: "Sequence"
    t.string "code", null: false, comment: "Code"
    t.float "number_of_days", comment: "Number of Days"
    t.float "number_of_hours", comment: "Number of Hours"
    t.integer "contract_id", null: false, comment: "Contract"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["payslip_id"], name: "hr_payslip_worked_days_payslip_id_index"
    t.index ["sequence"], name: "hr_payslip_worked_days_sequence_index"
  end

  create_table "hr_public_holiday", id: :serial, comment: "hr.public.holiday", force: :cascade do |t|
    t.integer "company_id", comment: "Company"
    t.integer "year", comment: "Year"
    t.string "state", comment: "State"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_public_holiday_line", id: :serial, comment: "hr.public.holiday.line", force: :cascade do |t|
    t.integer "holiday_id", comment: "Holiday"
    t.string "name", comment: "Name"
    t.date "from_date", comment: "From Date"
    t.date "to_date", comment: "To Date"
    t.date "replace_work", comment: "Replace Work"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_recruitment_degree", id: :serial, comment: "Degree of Recruitment", force: :cascade do |t|
    t.string "name", null: false, comment: "Degree"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "hr_recruitment_degree_name_uniq", unique: true
  end

  create_table "hr_recruitment_source", id: :serial, comment: "Source of Applicants", force: :cascade do |t|
    t.integer "source_id", null: false, comment: "Source"
    t.integer "job_id", comment: "Job ID"
    t.integer "alias_id", comment: "Alias ID"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_recruitment_stage", id: :serial, comment: "Stage of Recruitment", force: :cascade do |t|
    t.string "name", null: false, comment: "Stage name"
    t.integer "sequence", comment: "Sequence"
    t.integer "job_id", comment: "Job Specific"
    t.text "requirements", comment: "Requirements"
    t.integer "template_id", comment: "Automated Email"
    t.boolean "fold", comment: "Folded in Recruitment Pipe"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_rule_input", id: :serial, comment: "Salary Rule Input", force: :cascade do |t|
    t.string "name", null: false, comment: "Description"
    t.string "code", null: false, comment: "Code"
    t.integer "input_id", null: false, comment: "Salary Rule Input"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_salary_rule", id: :serial, comment: "hr.salary.rule", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "sequence", null: false, comment: "Sequence"
    t.string "quantity", comment: "Quantity"
    t.integer "category_id", null: false, comment: "Category"
    t.boolean "active", comment: "Active"
    t.boolean "appears_on_payslip", comment: "Appears on Payslip"
    t.integer "parent_rule_id", comment: "Parent Salary Rule"
    t.integer "company_id", comment: "Company"
    t.string "condition_select", null: false, comment: "Condition Based on"
    t.string "condition_range", comment: "Range Based on"
    t.text "condition_python", null: false, comment: "Python Condition"
    t.float "condition_range_min", comment: "Minimum Range"
    t.float "condition_range_max", comment: "Maximum Range"
    t.string "amount_select", null: false, comment: "Amount Type"
    t.decimal "amount_fix", comment: "Fixed Amount"
    t.decimal "amount_percentage", comment: "Percentage (%)"
    t.text "amount_python_compute", comment: "Python Code"
    t.string "amount_percentage_base", comment: "Percentage based on"
    t.integer "register_id", comment: "Contribution Register"
    t.text "note", comment: "Description"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["amount_select"], name: "hr_salary_rule_amount_select_index"
    t.index ["parent_rule_id"], name: "hr_salary_rule_parent_rule_id_index"
    t.index ["sequence"], name: "hr_salary_rule_sequence_index"
  end

  create_table "hr_salary_rule_category", id: :serial, comment: "Salary Rule Category", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "parent_id", comment: "Parent"
    t.text "note", comment: "Description"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "hr_structure_salary_rule_rel", id: false, comment: "RELATION BETWEEN hr_payroll_structure AND hr_salary_rule", force: :cascade do |t|
    t.integer "struct_id", null: false
    t.integer "rule_id", null: false
    t.index ["rule_id"], name: "hr_structure_salary_rule_rel_rule_id_idx"
    t.index ["struct_id", "rule_id"], name: "hr_structure_salary_rule_rel_struct_id_rule_id_key", unique: true
    t.index ["struct_id"], name: "hr_structure_salary_rule_rel_struct_id_idx"
  end

  create_table "hr_year", id: :serial, comment: "hr.year", force: :cascade do |t|
    t.integer "year", comment: "Year"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "iap_account", id: :serial, comment: "iap.account", force: :cascade do |t|
    t.string "service_name", comment: "Service Name"
    t.string "account_token", comment: "Account Token"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "im_livechat_channel", id: :serial, comment: "Livechat Channel", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "button_text", comment: "Text of the Button"
    t.string "default_message", comment: "Welcome Message"
    t.string "input_placeholder", comment: "Chat Input Placeholder"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.text "website_description", comment: "Website description"
    t.boolean "website_published", comment: "Visible in Website"
  end

  create_table "im_livechat_channel_country_rel", id: false, comment: "RELATION BETWEEN im_livechat_channel_rule AND res_country", force: :cascade do |t|
    t.integer "channel_id", null: false
    t.integer "country_id", null: false
    t.index ["channel_id", "country_id"], name: "im_livechat_channel_country_rel_channel_id_country_id_key", unique: true
    t.index ["channel_id"], name: "im_livechat_channel_country_rel_channel_id_idx"
    t.index ["country_id"], name: "im_livechat_channel_country_rel_country_id_idx"
  end

  create_table "im_livechat_channel_im_user", id: false, comment: "RELATION BETWEEN im_livechat_channel AND res_users", force: :cascade do |t|
    t.integer "channel_id", null: false
    t.integer "user_id", null: false
    t.index ["channel_id", "user_id"], name: "im_livechat_channel_im_user_channel_id_user_id_key", unique: true
    t.index ["channel_id"], name: "im_livechat_channel_im_user_channel_id_idx"
    t.index ["user_id"], name: "im_livechat_channel_im_user_user_id_idx"
  end

  create_table "im_livechat_channel_rule", id: :serial, comment: "Channel Rules", force: :cascade do |t|
    t.string "regex_url", comment: "URL Regex"
    t.string "action", null: false, comment: "Action"
    t.integer "auto_popup_timer", comment: "Auto popup timer"
    t.integer "channel_id", comment: "Channel"
    t.integer "sequence", comment: "Matching order"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "incoming_mail_job_rel", id: false, comment: "RELATION BETWEEN incomming_mail AND hr_job", force: :cascade do |t|
    t.integer "mail_id", null: false
    t.integer "job_id", null: false
    t.index ["job_id"], name: "incoming_mail_job_rel_job_id_idx"
    t.index ["mail_id", "job_id"], name: "incoming_mail_job_rel_mail_id_job_id_key", unique: true
    t.index ["mail_id"], name: "incoming_mail_job_rel_mail_id_idx"
  end

  create_table "incomming_mail", id: :serial, comment: "Incomming mail", force: :cascade do |t|
    t.integer "campaign_id", comment: "Campaign"
    t.integer "source_id", comment: "Source"
    t.integer "medium_id", comment: "Medium"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Subject"
    t.integer "partner_id", comment: "Partner"
    t.string "body", comment: "Body"
    t.string "cc", comment: "Cc"
    t.datetime "date", comment: "Date"
    t.string "email_from", comment: "Email From"
    t.string "str_from", comment: "Str From"
    t.string "message_id", comment: "Message"
    t.string "to", comment: "To"
    t.integer "attachment_count", comment: "Attachment Count"
    t.boolean "identified", comment: "Identified"
    t.string "state", comment: "State"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "source_number", comment: "Source Number"
    t.integer "job_id", comment: "Job"
    t.integer "tag_id", comment: "Tag"
  end

  create_table "incomming_mail_attachment_rel", id: false, comment: "RELATION BETWEEN incomming_mail AND ir_attachment", force: :cascade do |t|
    t.integer "mail_id", null: false
    t.integer "attachment_id", null: false
    t.index ["attachment_id"], name: "incomming_mail_attachment_rel_attachment_id_idx"
    t.index ["mail_id", "attachment_id"], name: "incomming_mail_attachment_rel_mail_id_attachment_id_key", unique: true
    t.index ["mail_id"], name: "incomming_mail_attachment_rel_mail_id_idx"
  end

  create_table "incomming_mail_tag", id: :serial, comment: "Tag", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.text "note", comment: "Note"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "ir_act_client", id: :integer, default: -> { "nextval('ir_actions_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.text "help"
    t.integer "binding_model_id"
    t.string "binding_type", null: false
    t.integer "create_uid"
    t.datetime "create_date"
    t.integer "write_uid"
    t.datetime "write_date"
    t.string "tag", null: false, comment: "Client action tag"
    t.string "target", comment: "Target Window"
    t.string "res_model", comment: "Destination Model"
    t.string "context", null: false, comment: "Context Value"
    t.binary "params_store", comment: "Params storage"
  end

  create_table "ir_act_report_xml", id: :integer, default: -> { "nextval('ir_actions_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.text "help"
    t.integer "binding_model_id"
    t.string "binding_type", null: false
    t.integer "create_uid"
    t.datetime "create_date"
    t.integer "write_uid"
    t.datetime "write_date"
    t.string "model", null: false, comment: "Model"
    t.string "report_type", null: false, comment: "Report Type"
    t.string "report_name", null: false, comment: "Template Name"
    t.string "report_file", comment: "Report File"
    t.boolean "multi", comment: "On Multiple Doc."
    t.integer "paperformat_id", comment: "Paper format"
    t.string "print_report_name", comment: "Printed Report Name"
    t.boolean "attachment_use", comment: "Reload from Attachment"
    t.string "attachment", comment: "Save as Attachment Prefix"
  end

  create_table "ir_act_server", id: :integer, default: -> { "nextval('ir_actions_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.text "help"
    t.integer "binding_model_id"
    t.string "binding_type", null: false
    t.integer "create_uid"
    t.datetime "create_date"
    t.integer "write_uid"
    t.datetime "write_date"
    t.string "usage", null: false, comment: "Usage"
    t.string "state", null: false, comment: "Action To Do"
    t.integer "sequence", comment: "Sequence"
    t.integer "model_id", null: false, comment: "Model"
    t.string "model_name", comment: "Model"
    t.text "code", comment: "Python Code"
    t.integer "crud_model_id", comment: "Create/Write Target Model"
    t.integer "link_field_id", comment: "Link using field"
    t.integer "template_id", comment: "Email Template"
    t.string "website_path", comment: "Website Path"
    t.boolean "website_published", comment: "Available on the Website"
  end

  create_table "ir_act_server_mail_channel_rel", id: false, comment: "RELATION BETWEEN ir_act_server AND mail_channel", force: :cascade do |t|
    t.integer "ir_act_server_id", null: false
    t.integer "mail_channel_id", null: false
    t.index ["ir_act_server_id", "mail_channel_id"], name: "ir_act_server_mail_channel_re_ir_act_server_id_mail_channel_key", unique: true
    t.index ["ir_act_server_id"], name: "ir_act_server_mail_channel_rel_ir_act_server_id_idx"
    t.index ["mail_channel_id"], name: "ir_act_server_mail_channel_rel_mail_channel_id_idx"
  end

  create_table "ir_act_server_res_partner_rel", id: false, comment: "RELATION BETWEEN ir_act_server AND res_partner", force: :cascade do |t|
    t.integer "ir_act_server_id", null: false
    t.integer "res_partner_id", null: false
    t.index ["ir_act_server_id", "res_partner_id"], name: "ir_act_server_res_partner_rel_ir_act_server_id_res_partner__key", unique: true
    t.index ["ir_act_server_id"], name: "ir_act_server_res_partner_rel_ir_act_server_id_idx"
    t.index ["res_partner_id"], name: "ir_act_server_res_partner_rel_res_partner_id_idx"
  end

  create_table "ir_act_url", id: :integer, default: -> { "nextval('ir_actions_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.text "help"
    t.integer "binding_model_id"
    t.string "binding_type", null: false
    t.integer "create_uid"
    t.datetime "create_date"
    t.integer "write_uid"
    t.datetime "write_date"
    t.text "url", null: false, comment: "Action URL"
    t.string "target", null: false, comment: "Action Target"
  end

  create_table "ir_act_window", id: :integer, default: -> { "nextval('ir_actions_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.text "help"
    t.integer "binding_model_id"
    t.string "binding_type", null: false
    t.integer "create_uid"
    t.datetime "create_date"
    t.integer "write_uid"
    t.datetime "write_date"
    t.integer "view_id", comment: "View Ref."
    t.string "domain", comment: "Domain Value"
    t.string "context", null: false, comment: "Context Value"
    t.integer "res_id", comment: "Record ID"
    t.string "res_model", null: false, comment: "Destination Model"
    t.string "src_model", comment: "Source Model"
    t.string "target", comment: "Target Window"
    t.string "view_mode", null: false, comment: "View Mode"
    t.string "view_type", null: false, comment: "View Type"
    t.string "usage", comment: "Action Usage"
    t.integer "limit", comment: "Limit"
    t.integer "search_view_id", comment: "Search View Ref."
    t.boolean "filter", comment: "Filter"
    t.boolean "auto_search", comment: "Auto Search"
    t.boolean "multi", comment: "Restrict to lists"
  end

  create_table "ir_act_window_group_rel", id: false, comment: "RELATION BETWEEN ir_act_window AND res_groups", force: :cascade do |t|
    t.integer "act_id", null: false
    t.integer "gid", null: false
    t.index ["act_id", "gid"], name: "ir_act_window_group_rel_act_id_gid_key", unique: true
    t.index ["act_id"], name: "ir_act_window_group_rel_act_id_idx"
    t.index ["gid"], name: "ir_act_window_group_rel_gid_idx"
  end

  create_table "ir_act_window_view", id: :serial, comment: "ir.actions.act_window.view", force: :cascade do |t|
    t.integer "sequence", comment: "Sequence"
    t.integer "view_id", comment: "View"
    t.string "view_mode", null: false, comment: "View Type"
    t.integer "act_window_id", comment: "Action"
    t.boolean "multi", comment: "On Multiple Doc."
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["act_window_id", "view_mode"], name: "act_window_view_unique_mode_per_action", unique: true
  end

  create_table "ir_actions", id: :serial, force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "type", null: false, comment: "Action Type"
    t.text "help", comment: "Action Description"
    t.integer "binding_model_id", comment: "Binding Model"
    t.string "binding_type", null: false, comment: "Binding Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "ir_actions_todo", id: :serial, comment: "Configuration Wizards", force: :cascade do |t|
    t.integer "action_id", null: false, comment: "Action"
    t.integer "sequence", comment: "Sequence"
    t.string "state", null: false, comment: "Status"
    t.string "name", comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["action_id"], name: "ir_actions_todo_action_id_index"
  end

  create_table "ir_attachment", id: :serial, comment: "ir.attachment", force: :cascade do |t|
    t.string "name", null: false, comment: "Attachment Name"
    t.string "datas_fname", comment: "File Name"
    t.text "description", comment: "Description"
    t.string "res_name", comment: "Resource Name"
    t.string "res_model", comment: "Resource Model"
    t.string "res_field", comment: "Resource Field"
    t.integer "res_id", comment: "Resource ID"
    t.datetime "create_date", comment: "Date Created"
    t.integer "create_uid", comment: "Owner"
    t.integer "company_id", comment: "Company"
    t.string "type", null: false, comment: "Type"
    t.string "url", limit: 1024, comment: "Url"
    t.boolean "public", comment: "Is public document"
    t.string "access_token", comment: "Access Token"
    t.binary "db_datas", comment: "Database Data"
    t.string "store_fname", comment: "Stored Filename"
    t.integer "file_size", comment: "File Size"
    t.string "checksum", limit: 40, comment: "Checksum/SHA1"
    t.string "mimetype", comment: "Mime Type"
    t.text "index_content", comment: "Indexed Content"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["checksum"], name: "ir_attachment_checksum_index"
    t.index ["res_model", "res_id"], name: "ir_attachment_res_idx"
    t.index ["res_model"], name: "ir_attachment_res_model_index"
    t.index ["url"], name: "ir_attachment_url_index"
  end

  create_table "ir_config_parameter", id: :serial, comment: "ir.config_parameter", force: :cascade do |t|
    t.string "key", null: false, comment: "Key"
    t.text "value", null: false, comment: "Value"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["key"], name: "ir_config_parameter_key_index"
    t.index ["key"], name: "ir_config_parameter_key_uniq", unique: true
  end

  create_table "ir_cron", id: :serial, comment: "Scheduled Actions", force: :cascade do |t|
    t.integer "ir_actions_server_id", null: false, comment: "Server action"
    t.string "cron_name", comment: "Name"
    t.integer "user_id", null: false, comment: "Scheduler User"
    t.boolean "active", comment: "Active"
    t.integer "interval_number", comment: "Interval Number"
    t.string "interval_type", comment: "Interval Unit"
    t.integer "numbercall", comment: "Number of Calls"
    t.boolean "doall", comment: "Repeat Missed"
    t.datetime "nextcall", null: false, comment: "Next Execution Date"
    t.integer "priority", comment: "Priority"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "ir_default", id: :serial, comment: "ir.default", force: :cascade do |t|
    t.integer "field_id", null: false, comment: "Field"
    t.integer "user_id", comment: "User"
    t.integer "company_id", comment: "Company"
    t.string "condition", comment: "Condition"
    t.string "json_value", null: false, comment: "Default Value (JSON format)"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["company_id"], name: "ir_default_company_id_index"
    t.index ["field_id"], name: "ir_default_field_id_index"
    t.index ["user_id"], name: "ir_default_user_id_index"
  end

  create_table "ir_exports", id: :serial, comment: "ir.exports", force: :cascade do |t|
    t.string "name", null: false, comment: "Export Name"
    t.string "resource", comment: "Resource"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "model_id", comment: "Model"
    t.index ["resource"], name: "ir_exports_resource_index"
  end

  create_table "ir_exports_line", id: :serial, comment: "ir.exports.line", force: :cascade do |t|
    t.string "name", comment: "Field Name"
    t.integer "export_id", comment: "Export"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "field1_id", comment: "First field"
    t.integer "field2_id", comment: "Second field"
    t.integer "field3_id", comment: "Third field"
    t.integer "field4_id", comment: "Fourth field"
    t.integer "sequence", comment: "Sequence"
    t.index ["export_id"], name: "ir_exports_line_export_id_index"
  end

  create_table "ir_filters", id: :serial, comment: "Filters", force: :cascade do |t|
    t.string "name", null: false, comment: "Filter Name"
    t.integer "user_id", comment: "User"
    t.text "domain", null: false, comment: "Domain"
    t.text "context", null: false, comment: "Context"
    t.text "sort", null: false, comment: "Sort"
    t.string "model_id", null: false, comment: "Model"
    t.boolean "is_default", comment: "Default Filter"
    t.integer "action_id", comment: "Action"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index "lower((name)::text), model_id, (COALESCE(user_id, '-1'::integer)), (COALESCE(action_id, '-1'::integer))", name: "ir_filters_name_model_uid_unique_action_index", unique: true
    t.index ["name", "model_id", "user_id", "action_id"], name: "ir_filters_name_model_uid_unique", unique: true
  end

  create_table "ir_logging", id: :serial, comment: "ir.logging", force: :cascade do |t|
    t.datetime "create_date", comment: "Create Date"
    t.integer "create_uid", comment: "Uid"
    t.string "name", null: false, comment: "Name"
    t.string "type", null: false, comment: "Type"
    t.string "dbname", comment: "Database Name"
    t.string "level", comment: "Level"
    t.text "message", null: false, comment: "Message"
    t.string "path", null: false, comment: "Path"
    t.string "func", null: false, comment: "Function"
    t.string "line", null: false, comment: "Line"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["dbname"], name: "ir_logging_dbname_index"
    t.index ["level"], name: "ir_logging_level_index"
    t.index ["type"], name: "ir_logging_type_index"
  end

  create_table "ir_logging_perf_rule", id: :serial, comment: "Perf Logging Rule", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.boolean "active", comment: "Active"
    t.string "methods", comment: "Methods"
    t.boolean "log_python", comment: "Profile Python methods"
    t.boolean "log_sql", comment: "Log SQL requests"
    t.string "path", comment: "Path"
    t.decimal "rpc_min_duration", comment: "Slow RPC calls - Min. duration"
    t.decimal "sql_min_duration", comment: "Slow SQL requests - Min. duration"
    t.decimal "recompute_min_duration", comment: "Slow fields recomputation - Min. duration"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "ir_logging_perf_rule_ir_model_rel", id: false, comment: "RELATION BETWEEN ir_logging_perf_rule AND ir_model", force: :cascade do |t|
    t.integer "ir_logging_perf_rule_id", null: false
    t.integer "ir_model_id", null: false
    t.index ["ir_logging_perf_rule_id", "ir_model_id"], name: "ir_logging_perf_rule_ir_model_ir_logging_perf_rule_id_ir_mo_key", unique: true
    t.index ["ir_logging_perf_rule_id"], name: "ir_logging_perf_rule_ir_model_rel_ir_logging_perf_rule_id_idx"
    t.index ["ir_model_id"], name: "ir_logging_perf_rule_ir_model_rel_ir_model_id_idx"
  end

  create_table "ir_logging_perf_rule_res_users_rel", id: false, comment: "RELATION BETWEEN ir_logging_perf_rule AND res_users", force: :cascade do |t|
    t.integer "ir_logging_perf_rule_id", null: false
    t.integer "res_users_id", null: false
    t.index ["ir_logging_perf_rule_id", "res_users_id"], name: "ir_logging_perf_rule_res_user_ir_logging_perf_rule_id_res_u_key", unique: true
    t.index ["ir_logging_perf_rule_id"], name: "ir_logging_perf_rule_res_users_rel_ir_logging_perf_rule_id_idx"
    t.index ["res_users_id"], name: "ir_logging_perf_rule_res_users_rel_res_users_id_idx"
  end

  create_table "ir_mail_server", id: :serial, comment: "ir.mail_server", force: :cascade do |t|
    t.string "name", null: false, comment: "Description"
    t.string "smtp_host", null: false, comment: "SMTP Server"
    t.integer "smtp_port", null: false, comment: "SMTP Port"
    t.string "smtp_user", comment: "Username"
    t.string "smtp_pass", comment: "Password"
    t.string "smtp_encryption", null: false, comment: "Connection Security"
    t.boolean "smtp_debug", comment: "Debugging"
    t.integer "sequence", comment: "Priority"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "ir_mail_server_name_index"
  end

  create_table "ir_model", id: :serial, comment: "Models", force: :cascade do |t|
    t.string "name", null: false, comment: "Model Description"
    t.string "model", null: false, comment: "Model"
    t.text "info", comment: "Information"
    t.string "state", comment: "Type"
    t.boolean "transient", comment: "Transient Model"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "is_mail_thread", comment: "Mail Thread"
    t.boolean "website_form_access", comment: "Allowed to use in forms"
    t.integer "website_form_default_field_id", comment: "Field for custom form data"
    t.string "website_form_label", comment: "Label for form action"
    t.index ["model"], name: "ir_model_model_index"
    t.index ["model"], name: "ir_model_obj_name_uniq", unique: true
  end

  create_table "ir_model_access", id: :serial, comment: "ir.model.access", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.boolean "active", comment: "Active"
    t.integer "model_id", null: false, comment: "Object"
    t.integer "group_id", comment: "Group"
    t.boolean "perm_read", comment: "Read Access"
    t.boolean "perm_write", comment: "Write Access"
    t.boolean "perm_create", comment: "Create Access"
    t.boolean "perm_unlink", comment: "Delete Access"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "perm_export", comment: "Export Access"
    t.index ["group_id"], name: "ir_model_access_group_id_index"
    t.index ["model_id"], name: "ir_model_access_model_id_index"
    t.index ["name"], name: "ir_model_access_name_index"
  end

  create_table "ir_model_constraint", id: :serial, comment: "ir.model.constraint", force: :cascade do |t|
    t.string "name", null: false, comment: "Constraint"
    t.string "definition", comment: "Definition"
    t.integer "model", null: false, comment: "Model"
    t.integer "module", null: false, comment: "Module"
    t.string "type", limit: 1, null: false, comment: "Constraint Type"
    t.datetime "date_update", comment: "Update Date"
    t.datetime "date_init", comment: "Initialization Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["model"], name: "ir_model_constraint_model_index"
    t.index ["module"], name: "ir_model_constraint_module_index"
    t.index ["name", "module"], name: "ir_model_constraint_module_name_uniq", unique: true
    t.index ["name"], name: "ir_model_constraint_name_index"
    t.index ["type"], name: "ir_model_constraint_type_index"
  end

  create_table "ir_model_data", id: :serial, force: :cascade do |t|
    t.integer "create_uid"
    t.datetime "create_date"
    t.datetime "write_date"
    t.integer "write_uid"
    t.boolean "noupdate"
    t.string "name", null: false
    t.datetime "date_init"
    t.datetime "date_update"
    t.string "module", null: false
    t.string "model", null: false
    t.integer "res_id"
    t.index ["model", "res_id"], name: "ir_model_data_model_res_id_index"
    t.index ["module", "name"], name: "ir_model_data_module_name_uniq_index", unique: true
  end

  create_table "ir_model_fields", id: :serial, comment: "Fields", force: :cascade do |t|
    t.string "name", null: false, comment: "Field Name"
    t.string "complete_name", comment: "Complete Name"
    t.string "model", null: false, comment: "Object Name"
    t.string "relation", comment: "Object Relation"
    t.string "relation_field", comment: "Relation Field"
    t.integer "model_id", null: false, comment: "Model"
    t.string "field_description", null: false, comment: "Field Label"
    t.text "help", comment: "Field Help"
    t.string "ttype", null: false, comment: "Field Type"
    t.string "selection", comment: "Selection Options"
    t.boolean "copy", comment: "Copied"
    t.string "related", comment: "Related Field"
    t.boolean "required", comment: "Required"
    t.boolean "readonly", comment: "Readonly"
    t.boolean "index", comment: "Indexed"
    t.boolean "translate", comment: "Translatable"
    t.integer "size", comment: "Size"
    t.string "state", null: false, comment: "Type"
    t.string "on_delete", comment: "On Delete"
    t.string "domain", comment: "Domain"
    t.boolean "selectable", comment: "Selectable"
    t.string "relation_table", comment: "Relation Table"
    t.string "column1", comment: "Column 1"
    t.string "column2", comment: "Column 2"
    t.text "compute", comment: "Compute"
    t.string "depends", comment: "Dependencies"
    t.boolean "store", comment: "Stored"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "track_visibility", comment: "Tracking"
    t.boolean "website_form_blacklisted", default: true, comment: "Blacklisted in web forms"
    t.integer "serialization_field_id", comment: "Serialization Field"
    t.index ["complete_name"], name: "ir_model_fields_complete_name_index"
    t.index ["model", "name"], name: "ir_model_fields_name_unique", unique: true
    t.index ["model"], name: "ir_model_fields_model_index"
    t.index ["model_id"], name: "ir_model_fields_model_id_index"
    t.index ["name"], name: "ir_model_fields_name_index"
    t.index ["state"], name: "ir_model_fields_state_index"
    t.index ["website_form_blacklisted"], name: "ir_model_fields_website_form_blacklisted_index"
  end

  create_table "ir_model_fields_group_rel", id: false, comment: "RELATION BETWEEN ir_model_fields AND res_groups", force: :cascade do |t|
    t.integer "field_id", null: false
    t.integer "group_id", null: false
    t.index ["field_id", "group_id"], name: "ir_model_fields_group_rel_field_id_group_id_key", unique: true
    t.index ["field_id"], name: "ir_model_fields_group_rel_field_id_idx"
    t.index ["group_id"], name: "ir_model_fields_group_rel_group_id_idx"
  end

  create_table "ir_model_relation", id: :serial, comment: "ir.model.relation", force: :cascade do |t|
    t.string "name", null: false, comment: "Relation Name"
    t.integer "model", null: false, comment: "Model"
    t.integer "module", null: false, comment: "Module"
    t.datetime "date_update", comment: "Update Date"
    t.datetime "date_init", comment: "Initialization Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["model"], name: "ir_model_relation_model_index"
    t.index ["module"], name: "ir_model_relation_module_index"
    t.index ["name"], name: "ir_model_relation_name_index"
  end

  create_table "ir_module_category", id: :serial, force: :cascade do |t|
    t.integer "create_uid"
    t.datetime "create_date"
    t.datetime "write_date"
    t.integer "write_uid"
    t.integer "parent_id"
    t.string "name", null: false
    t.text "description", comment: "Description"
    t.integer "sequence", comment: "Sequence"
    t.boolean "visible", comment: "Visible"
    t.boolean "exclusive", comment: "Exclusive"
    t.index ["name"], name: "ir_module_category_name_index"
    t.index ["parent_id"], name: "ir_module_category_parent_id_index"
  end

  create_table "ir_module_module", id: :serial, force: :cascade do |t|
    t.integer "create_uid"
    t.datetime "create_date"
    t.datetime "write_date"
    t.integer "write_uid"
    t.string "website"
    t.string "summary"
    t.string "name", null: false
    t.string "author"
    t.string "icon"
    t.string "state", limit: 16
    t.string "latest_version"
    t.string "shortdesc"
    t.integer "category_id"
    t.text "description"
    t.boolean "application", default: false
    t.boolean "demo", default: false
    t.boolean "web", default: false
    t.string "license", limit: 32
    t.integer "sequence", default: 100
    t.boolean "auto_install", default: false
    t.string "maintainer", comment: "Maintainer"
    t.text "contributors", comment: "Contributors"
    t.string "published_version", comment: "Published Version"
    t.string "url", comment: "URL"
    t.text "menus_by_module", comment: "Menus"
    t.text "reports_by_module", comment: "Reports"
    t.text "views_by_module", comment: "Views"
    t.index ["category_id"], name: "ir_module_module_category_id_index"
    t.index ["name"], name: "ir_module_module_name_index"
    t.index ["name"], name: "ir_module_module_name_uniq", unique: true
    t.index ["name"], name: "name_uniq", unique: true
    t.index ["state"], name: "ir_module_module_state_index"
  end

  create_table "ir_module_module_dependency", id: :serial, force: :cascade do |t|
    t.integer "create_uid"
    t.datetime "create_date"
    t.datetime "write_date"
    t.integer "write_uid"
    t.string "name"
    t.integer "module_id"
    t.index ["name"], name: "ir_module_module_dependency_name_index"
  end

  create_table "ir_module_module_exclusion", id: :serial, comment: "Module exclusion", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "module_id", comment: "Module"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "ir_module_module_exclusion_name_index"
  end

  create_table "ir_property", id: :serial, comment: "ir.property", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.string "res_id", comment: "Resource"
    t.integer "company_id", comment: "Company"
    t.integer "fields_id", null: false, comment: "Field"
    t.float "value_float", comment: "Value Float"
    t.integer "value_integer", comment: "Value Integer"
    t.text "value_text", comment: "Value Text"
    t.binary "value_binary", comment: "Value Binary"
    t.string "value_reference", comment: "Value Reference"
    t.datetime "value_datetime", comment: "Value Datetime"
    t.string "type", null: false, comment: "Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["company_id"], name: "ir_property_company_id_index"
    t.index ["fields_id"], name: "ir_property_fields_id_index"
    t.index ["name"], name: "ir_property_name_index"
    t.index ["res_id"], name: "ir_property_res_id_index"
    t.index ["type"], name: "ir_property_type_index"
  end

  create_table "ir_rule", id: :serial, comment: "ir.rule", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.boolean "active", comment: "Active"
    t.integer "model_id", null: false, comment: "Object"
    t.text "domain_force", comment: "Domain"
    t.boolean "perm_read", comment: "Apply for Read"
    t.boolean "perm_write", comment: "Apply for Write"
    t.boolean "perm_create", comment: "Apply for Create"
    t.boolean "perm_unlink", comment: "Apply for Delete"
    t.boolean "global", comment: "Global"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["model_id"], name: "ir_rule_model_id_index"
    t.index ["name"], name: "ir_rule_name_index"
  end

  create_table "ir_sequence", id: :serial, comment: "ir.sequence", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", comment: "Sequence Code"
    t.string "implementation", null: false, comment: "Implementation"
    t.boolean "active", comment: "Active"
    t.string "prefix", comment: "Prefix"
    t.string "suffix", comment: "Suffix"
    t.integer "number_next", null: false, comment: "Next Number"
    t.integer "number_increment", null: false, comment: "Step"
    t.integer "padding", null: false, comment: "Sequence Size"
    t.integer "company_id", comment: "Company"
    t.boolean "use_date_range", comment: "Use subsequences per date_range"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "ir_sequence_date_range", id: :serial, comment: "ir.sequence.date_range", force: :cascade do |t|
    t.date "date_from", null: false, comment: "From"
    t.date "date_to", null: false, comment: "To"
    t.integer "sequence_id", null: false, comment: "Main Sequence"
    t.integer "number_next", null: false, comment: "Next Number"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "ir_server_object_lines", id: :serial, comment: "Server Action value mapping", force: :cascade do |t|
    t.integer "server_id", comment: "Related Server Action"
    t.integer "col1", null: false, comment: "Field"
    t.text "value", null: false, comment: "Value"
    t.string "type", null: false, comment: "Evaluation Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "ir_translation", id: :serial, comment: "ir.translation", force: :cascade do |t|
    t.string "name", null: false, comment: "Translated field"
    t.integer "res_id", comment: "Record ID"
    t.string "lang", comment: "Language"
    t.string "type", comment: "Type"
    t.text "src", comment: "Internal Source"
    t.text "value", comment: "Translation Value"
    t.string "module", comment: "Module"
    t.string "state", comment: "Status"
    t.text "comments", comment: "Translation comments"
    t.index "md5(src)", name: "ir_translation_src_md5"
    t.index ["comments"], name: "ir_translation_comments_index"
    t.index ["module"], name: "ir_translation_module_index"
    t.index ["name", "lang", "type"], name: "ir_translation_ltn"
    t.index ["res_id"], name: "ir_translation_res_id_index"
    t.index ["type"], name: "ir_translation_type_index"
  end

  create_table "ir_ui_menu", id: :serial, comment: "ir.ui.menu", force: :cascade do |t|
    t.integer "parent_left"
    t.integer "parent_right"
    t.string "name", null: false, comment: "Menu"
    t.boolean "active", comment: "Active"
    t.integer "sequence", comment: "Sequence"
    t.integer "parent_id", comment: "Parent Menu"
    t.string "web_icon", comment: "Web Icon File"
    t.string "action", comment: "Action"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["parent_id"], name: "ir_ui_menu_parent_id_index"
    t.index ["parent_left"], name: "ir_ui_menu_parent_left_index"
    t.index ["parent_right"], name: "ir_ui_menu_parent_right_index"
  end

  create_table "ir_ui_menu_group_rel", id: false, comment: "RELATION BETWEEN ir_ui_menu AND res_groups", force: :cascade do |t|
    t.integer "menu_id", null: false
    t.integer "gid", null: false
    t.index ["gid"], name: "ir_ui_menu_group_rel_gid_idx"
    t.index ["menu_id", "gid"], name: "ir_ui_menu_group_rel_menu_id_gid_key", unique: true
    t.index ["menu_id"], name: "ir_ui_menu_group_rel_menu_id_idx"
  end

  create_table "ir_ui_view", id: :serial, comment: "ir.ui.view", force: :cascade do |t|
    t.string "name", null: false, comment: "View Name"
    t.string "model", comment: "Model"
    t.string "key", comment: "Key"
    t.integer "priority", null: false, comment: "Sequence"
    t.string "type", comment: "View Type"
    t.text "arch_db", comment: "Arch Blob"
    t.string "arch_fs", comment: "Arch Filename"
    t.integer "inherit_id", comment: "Inherited View"
    t.string "field_parent", comment: "Child Field"
    t.datetime "create_date", comment: "Create Date"
    t.datetime "write_date", comment: "Last Modification Date"
    t.string "mode", null: false, comment: "View inheritance mode"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.boolean "customize_show", comment: "Show As Optional Inherit"
    t.integer "website_id", comment: "Website"
    t.string "website_meta_title", comment: "Website meta title"
    t.text "website_meta_description", comment: "Website meta description"
    t.string "website_meta_keywords", comment: "Website meta keywords"
    t.index ["inherit_id"], name: "ir_ui_view_inherit_id_index"
    t.index ["model", "inherit_id"], name: "ir_ui_view_model_type_inherit_id"
    t.index ["model"], name: "ir_ui_view_model_index"
  end

  create_table "ir_ui_view_custom", id: :serial, comment: "ir.ui.view.custom", force: :cascade do |t|
    t.integer "ref_id", null: false, comment: "Original View"
    t.integer "user_id", null: false, comment: "User"
    t.text "arch", null: false, comment: "View Architecture"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["ref_id"], name: "ir_ui_view_custom_ref_id_index"
    t.index ["user_id", "ref_id"], name: "ir_ui_view_custom_user_id_ref_id"
    t.index ["user_id"], name: "ir_ui_view_custom_user_id_index"
  end

  create_table "ir_ui_view_group_rel", id: false, comment: "RELATION BETWEEN ir_ui_view AND res_groups", force: :cascade do |t|
    t.integer "view_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id"], name: "ir_ui_view_group_rel_group_id_idx"
    t.index ["view_id", "group_id"], name: "ir_ui_view_group_rel_view_id_group_id_key", unique: true
    t.index ["view_id"], name: "ir_ui_view_group_rel_view_id_idx"
  end

  create_table "issue_media", id: :serial, comment: "issue.media", force: :cascade do |t|
    t.integer "media_id", null: false, comment: "Media"
    t.integer "media_unit_id", null: false, comment: "Media Unit"
    t.string "type", null: false, comment: "Type"
    t.integer "student_id", comment: "Student"
    t.integer "faculty_id", comment: "Faculty"
    t.integer "library_card_id", null: false, comment: "Library Card"
    t.date "issued_date", null: false, comment: "Issued Date"
    t.date "return_date", null: false, comment: "Return Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "job_cv_rel", id: false, comment: "RELATION BETWEEN ir_attachment AND hr_job", force: :cascade do |t|
    t.integer "cv_id", null: false
    t.integer "job_id", null: false
    t.index ["cv_id", "job_id"], name: "job_cv_rel_cv_id_job_id_key", unique: true
    t.index ["cv_id"], name: "job_cv_rel_cv_id_idx"
    t.index ["job_id"], name: "job_cv_rel_job_id_idx"
  end

  create_table "learning_materials", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "material_type"
    t.string "learning_type"
    t.bigint "op_lession_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_drive_file_id"
    t.string "google_drive_link"
    t.string "ziggeo_file_id"
    t.index ["op_lession_id"], name: "index_learning_materials_on_op_lession_id"
  end

  create_table "link_tracker", id: :serial, comment: "link.tracker", force: :cascade do |t|
    t.string "url", null: false, comment: "Target URL"
    t.integer "count", comment: "Number of Clicks"
    t.string "title", comment: "Page Title"
    t.string "favicon", comment: "Favicon"
    t.integer "campaign_id", comment: "Campaign"
    t.integer "source_id", comment: "Source"
    t.integer "medium_id", comment: "Medium"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "mass_mailing_id", comment: "Mass Mailing"
    t.integer "mass_mailing_campaign_id", comment: "Mass Mailing Campaign"
  end

  create_table "link_tracker_click", id: :serial, comment: "link.tracker.click", force: :cascade do |t|
    t.date "click_date", comment: "Create Date"
    t.integer "link_id", null: false, comment: "Link"
    t.string "ip", comment: "Internet Protocol"
    t.integer "country_id", comment: "Country"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "mail_stat_id", comment: "Mail Statistics"
    t.integer "mass_mailing_id", comment: "Mass Mailing"
    t.integer "mass_mailing_campaign_id", comment: "Mass Mailing Campaign"
  end

  create_table "link_tracker_code", id: :serial, comment: "link.tracker.code", force: :cascade do |t|
    t.string "code", comment: "Short URL Code"
    t.integer "link_id", null: false, comment: "Link"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "link_tracker_code_code", unique: true
  end

  create_table "mail_activity", id: :serial, comment: "Activity", force: :cascade do |t|
    t.integer "res_id", null: false, comment: "Related Document ID"
    t.integer "res_model_id", null: false, comment: "Related Document Model"
    t.string "res_model", comment: "Related Document Model"
    t.string "res_name", comment: "Document Name"
    t.integer "activity_type_id", comment: "Activity"
    t.string "summary", comment: "Summary"
    t.text "note", comment: "Note"
    t.text "feedback", comment: "Feedback"
    t.date "date_deadline", null: false, comment: "Due Date"
    t.integer "user_id", null: false, comment: "Assigned to"
    t.integer "recommended_activity_type_id", comment: "Recommended Activity Type"
    t.integer "previous_activity_type_id", comment: "Previous Activity Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "calendar_event_id", comment: "Calendar Meeting"
    t.boolean "done"
    t.boolean "active", comment: "Active"
    t.date "date_done", comment: "Completed Date"
    t.string "result", comment: "Result"
    t.datetime "datetime_deadline", comment: "Due Datetime"
    t.index ["date_deadline"], name: "mail_activity_date_deadline_index"
    t.index ["date_done"], name: "mail_activity_date_done_index"
    t.index ["res_id"], name: "mail_activity_res_id_index"
    t.index ["res_model"], name: "mail_activity_res_model_index"
    t.index ["res_model_id"], name: "mail_activity_res_model_id_index"
    t.index ["user_id"], name: "mail_activity_user_id_index"
  end

  create_table "mail_activity_rel", id: false, comment: "RELATION BETWEEN mail_activity_type AND mail_activity_type", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "recommended_id", null: false
    t.index ["activity_id", "recommended_id"], name: "mail_activity_rel_activity_id_recommended_id_key", unique: true
    t.index ["activity_id"], name: "mail_activity_rel_activity_id_idx"
    t.index ["recommended_id"], name: "mail_activity_rel_recommended_id_idx"
  end

  create_table "mail_activity_type", id: :serial, comment: "Activity Type", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "summary", comment: "Summary"
    t.integer "sequence", comment: "Sequence"
    t.integer "days", comment: "# Days"
    t.string "icon", comment: "Icon"
    t.integer "res_model_id", comment: "Model"
    t.string "category", comment: "Category"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["res_model_id"], name: "mail_activity_type_res_model_id_index"
  end

  create_table "mail_alias", id: :serial, comment: "Email Aliases", force: :cascade do |t|
    t.string "alias_name", comment: "Alias Name"
    t.integer "alias_model_id", null: false, comment: "Aliased Model"
    t.integer "alias_user_id", comment: "Owner"
    t.text "alias_defaults", null: false, comment: "Default Values"
    t.integer "alias_force_thread_id", comment: "Record Thread ID"
    t.integer "alias_parent_model_id", comment: "Parent Model"
    t.integer "alias_parent_thread_id", comment: "Parent Record Thread ID"
    t.string "alias_contact", null: false, comment: "Alias Contact Security"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["alias_name"], name: "mail_alias_alias_unique", unique: true
  end

  create_table "mail_channel", id: :serial, comment: "Discussion channel", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Name"
    t.string "channel_type", comment: "Channel Type"
    t.text "description", comment: "Description"
    t.string "uuid", limit: 50, comment: "UUID"
    t.boolean "email_send", comment: "Send messages by email"
    t.string "public", null: false, comment: "Privacy"
    t.integer "group_public_id", comment: "Authorized Group"
    t.integer "alias_id", null: false, comment: "Alias"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "anonymous_name", comment: "Anonymous Name"
    t.integer "livechat_channel_id", comment: "Channel"
    t.float "rating_last_value", comment: "Rating Last Value"
    t.index ["uuid"], name: "mail_channel_uuid_index"
  end

  create_table "mail_channel_mail_wizard_invite_rel", id: false, comment: "RELATION BETWEEN mail_wizard_invite AND mail_channel", force: :cascade do |t|
    t.integer "mail_wizard_invite_id", null: false
    t.integer "mail_channel_id", null: false
    t.index ["mail_channel_id"], name: "mail_channel_mail_wizard_invite_rel_mail_channel_id_idx"
    t.index ["mail_wizard_invite_id", "mail_channel_id"], name: "mail_channel_mail_wizard_invi_mail_wizard_invite_id_mail_ch_key", unique: true
    t.index ["mail_wizard_invite_id"], name: "mail_channel_mail_wizard_invite_rel_mail_wizard_invite_id_idx"
  end

  create_table "mail_channel_partner", id: :serial, comment: "Listeners of a Channel", force: :cascade do |t|
    t.integer "partner_id", comment: "Recipient"
    t.integer "channel_id", comment: "Channel"
    t.integer "seen_message_id", comment: "Last Seen"
    t.string "fold_state", comment: "Conversation Fold State"
    t.boolean "is_minimized", comment: "Conversation is minimized"
    t.boolean "is_pinned", comment: "Is pinned on the interface"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["channel_id", "partner_id", "seen_message_id"], name: "mail_channel_partner_seen_message_id_idx"
  end

  create_table "mail_channel_res_groups_rel", id: false, comment: "RELATION BETWEEN mail_channel AND res_groups", force: :cascade do |t|
    t.integer "mail_channel_id", null: false
    t.integer "res_groups_id", null: false
    t.index ["mail_channel_id", "res_groups_id"], name: "mail_channel_res_groups_rel_mail_channel_id_res_groups_id_key", unique: true
    t.index ["mail_channel_id"], name: "mail_channel_res_groups_rel_mail_channel_id_idx"
    t.index ["res_groups_id"], name: "mail_channel_res_groups_rel_res_groups_id_idx"
  end

  create_table "mail_compose_message", id: :serial, comment: "Email composition wizard", force: :cascade do |t|
    t.datetime "date", comment: "Date"
    t.text "body", comment: "Contents"
    t.integer "parent_id", comment: "Parent Message"
    t.string "model", comment: "Related Document Model"
    t.integer "res_id", comment: "Related Document ID"
    t.string "record_name", comment: "Message Record Name"
    t.integer "mail_activity_type_id", comment: "Mail Activity Type"
    t.string "email_from", comment: "From"
    t.integer "author_id", comment: "Author"
    t.boolean "no_auto_thread", comment: "No threading for answers"
    t.string "message_id", comment: "Message-Id"
    t.string "reply_to", comment: "Reply-To"
    t.integer "mail_server_id", comment: "Outgoing mail server"
    t.string "composition_mode", comment: "Composition mode"
    t.boolean "use_active_domain", comment: "Use active domain"
    t.text "active_domain", comment: "Active domain"
    t.boolean "is_log", comment: "Log an Internal Note"
    t.string "subject", comment: "Subject"
    t.boolean "notify", comment: "Notify followers"
    t.boolean "auto_delete", comment: "Delete Emails"
    t.boolean "auto_delete_message", comment: "Delete Message Copy"
    t.integer "template_id", comment: "Use template"
    t.string "message_type", null: false, comment: "Type"
    t.integer "subtype_id", comment: "Subtype"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "mass_mailing_campaign_id", comment: "Mass Mailing Campaign"
    t.integer "mass_mailing_id", comment: "Mass Mailing"
    t.string "mass_mailing_name", comment: "Mass Mailing"
    t.boolean "website_published", comment: "Published"
    t.float "rating_value", comment: "Rating Value"
    t.index ["author_id"], name: "mail_compose_message_author_id_index"
    t.index ["mail_activity_type_id"], name: "mail_compose_message_mail_activity_type_id_index"
    t.index ["message_id"], name: "mail_compose_message_message_id_index"
    t.index ["model"], name: "mail_compose_message_model_index"
    t.index ["parent_id"], name: "mail_compose_message_parent_id_index"
    t.index ["res_id"], name: "mail_compose_message_res_id_index"
    t.index ["subtype_id"], name: "mail_compose_message_subtype_id_index"
    t.index ["template_id"], name: "mail_compose_message_template_id_index"
  end

  create_table "mail_compose_message_ir_attachments_rel", id: false, comment: "RELATION BETWEEN mail_compose_message AND ir_attachment", force: :cascade do |t|
    t.integer "wizard_id", null: false
    t.integer "attachment_id", null: false
    t.index ["attachment_id"], name: "mail_compose_message_ir_attachments_rel_attachment_id_idx"
    t.index ["wizard_id", "attachment_id"], name: "mail_compose_message_ir_attachments_wizard_id_attachment_id_key", unique: true
    t.index ["wizard_id"], name: "mail_compose_message_ir_attachments_rel_wizard_id_idx"
  end

  create_table "mail_compose_message_mail_mass_mailing_list_rel", id: false, comment: "RELATION BETWEEN mail_compose_message AND mail_mass_mailing_list", force: :cascade do |t|
    t.integer "mail_compose_message_id", null: false
    t.integer "mail_mass_mailing_list_id", null: false
    t.index ["mail_compose_message_id", "mail_mass_mailing_list_id"], name: "mail_compose_message_mail_mas_mail_compose_message_id_mail__key", unique: true
    t.index ["mail_compose_message_id"], name: "mail_compose_message_mail_mass_mail_mail_compose_message_id_idx"
    t.index ["mail_mass_mailing_list_id"], name: "mail_compose_message_mail_mass_ma_mail_mass_mailing_list_id_idx"
  end

  create_table "mail_compose_message_res_partner_rel", id: false, comment: "RELATION BETWEEN mail_compose_message AND res_partner", force: :cascade do |t|
    t.integer "wizard_id", null: false
    t.integer "partner_id", null: false
    t.index ["partner_id"], name: "mail_compose_message_res_partner_rel_partner_id_idx"
    t.index ["wizard_id", "partner_id"], name: "mail_compose_message_res_partner_rel_wizard_id_partner_id_key", unique: true
    t.index ["wizard_id"], name: "mail_compose_message_res_partner_rel_wizard_id_idx"
  end

  create_table "mail_followers", id: :serial, comment: "Document Followers", force: :cascade do |t|
    t.string "res_model", null: false, comment: "Related Document Model Name"
    t.integer "res_id", comment: "Related Document ID"
    t.integer "partner_id", comment: "Related Partner"
    t.integer "channel_id", comment: "Listener"
    t.index ["channel_id"], name: "mail_followers_channel_id_index"
    t.index ["partner_id"], name: "mail_followers_partner_id_index"
    t.index ["res_id"], name: "mail_followers_res_id_index"
    t.index ["res_model", "res_id", "channel_id"], name: "mail_followers_mail_followers_res_channel_res_model_id_uniq", unique: true
    t.index ["res_model", "res_id", "partner_id"], name: "mail_followers_mail_followers_res_partner_res_model_id_uniq", unique: true
    t.index ["res_model"], name: "mail_followers_res_model_index"
  end

  create_table "mail_followers_mail_message_subtype_rel", id: false, comment: "RELATION BETWEEN mail_followers AND mail_message_subtype", force: :cascade do |t|
    t.integer "mail_followers_id", null: false
    t.integer "mail_message_subtype_id", null: false
    t.index ["mail_followers_id", "mail_message_subtype_id"], name: "mail_followers_mail_message_s_mail_followers_id_mail_messag_key", unique: true
    t.index ["mail_followers_id"], name: "mail_followers_mail_message_subtype_rel_mail_followers_id_idx"
    t.index ["mail_message_subtype_id"], name: "mail_followers_mail_message_subtype_mail_message_subtype_id_idx"
  end

  create_table "mail_mail", id: :serial, comment: "Outgoing Mails", force: :cascade do |t|
    t.integer "mail_message_id", null: false, comment: "Message"
    t.text "body_html", comment: "Rich-text Contents"
    t.text "references", comment: "References"
    t.text "headers", comment: "Headers"
    t.boolean "notification", comment: "Is Notification"
    t.text "email_to", comment: "To"
    t.string "email_cc", comment: "Cc"
    t.string "state", comment: "Status"
    t.boolean "auto_delete", comment: "Auto Delete"
    t.text "failure_reason", comment: "Failure Reason"
    t.string "scheduled_date", comment: "Scheduled Send Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "fetchmail_server_id", comment: "Inbound Mail Server"
    t.integer "mailing_id", comment: "Mass Mailing"
    t.index ["fetchmail_server_id"], name: "mail_mail_fetchmail_server_id_index"
    t.index ["mail_message_id"], name: "mail_mail_mail_message_id_index"
  end

  create_table "mail_mail_res_partner_rel", id: false, comment: "RELATION BETWEEN mail_mail AND res_partner", force: :cascade do |t|
    t.integer "mail_mail_id", null: false
    t.integer "res_partner_id", null: false
    t.index ["mail_mail_id", "res_partner_id"], name: "mail_mail_res_partner_rel_mail_mail_id_res_partner_id_key", unique: true
    t.index ["mail_mail_id"], name: "mail_mail_res_partner_rel_mail_mail_id_idx"
    t.index ["res_partner_id"], name: "mail_mail_res_partner_rel_res_partner_id_idx"
  end

  create_table "mail_mail_statistics", id: :serial, comment: "Email Statistics", force: :cascade do |t|
    t.integer "mail_mail_id", comment: "Mail"
    t.integer "mail_mail_id_int", comment: "Mail ID (tech)"
    t.string "message_id", comment: "Message-ID"
    t.string "model", comment: "Document model"
    t.integer "res_id", comment: "Document ID"
    t.integer "mass_mailing_id", comment: "Mass Mailing"
    t.integer "mass_mailing_campaign_id", comment: "Mass Mailing Campaign"
    t.datetime "scheduled", comment: "Scheduled"
    t.datetime "sent", comment: "Sent"
    t.datetime "exception", comment: "Exception"
    t.datetime "opened", comment: "Opened"
    t.datetime "replied", comment: "Replied"
    t.datetime "bounced", comment: "Bounced"
    t.datetime "clicked", comment: "Clicked"
    t.string "state", comment: "State"
    t.datetime "state_update", comment: "State Update"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["mail_mail_id"], name: "mail_mail_statistics_mail_mail_id_index"
    t.index ["mail_mail_id_int"], name: "mail_mail_statistics_mail_mail_id_int_index"
  end

  create_table "mail_mass_mailing", id: :serial, comment: "Mass Mailing", force: :cascade do |t|
    t.boolean "active", comment: "Active"
    t.string "email_from", null: false, comment: "From"
    t.datetime "create_date", comment: "Creation Date"
    t.datetime "sent_date", comment: "Sent Date"
    t.datetime "schedule_date", comment: "Schedule in the Future"
    t.text "body_html", comment: "Body"
    t.boolean "keep_archives", comment: "Keep Archives"
    t.integer "mass_mailing_campaign_id", comment: "Mass Mailing Campaign"
    t.integer "campaign_id", comment: "Campaign"
    t.integer "source_id", null: false, comment: "Subject"
    t.integer "medium_id", comment: "Medium"
    t.string "state", null: false, comment: "Status"
    t.integer "color", comment: "Color Index"
    t.string "reply_to_mode", null: false, comment: "Reply-To Mode"
    t.string "reply_to", comment: "Reply To"
    t.integer "mailing_model_id", comment: "Recipients Model"
    t.string "mailing_domain", comment: "Domain"
    t.integer "contact_ab_pc", comment: "A/B Testing percentage"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mail_mass_mailing_campaign", id: :serial, comment: "Mass Mailing Campaign", force: :cascade do |t|
    t.integer "stage_id", null: false, comment: "Stage"
    t.integer "user_id", null: false, comment: "Responsible"
    t.integer "campaign_id", null: false, comment: "campaign_id"
    t.integer "source_id", comment: "Source"
    t.integer "medium_id", comment: "Medium"
    t.boolean "unique_ab_testing", comment: "Allow A/B Testing"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mail_mass_mailing_contact", id: :serial, comment: "Mass Mailing Contact", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.string "company_name", comment: "Company Name"
    t.integer "title_id", comment: "Title"
    t.string "email", null: false, comment: "Email"
    t.datetime "create_date", comment: "Creation Date"
    t.boolean "opt_out", comment: "Opt Out"
    t.datetime "unsubscription_date", comment: "Unsubscription Date"
    t.integer "message_bounce", comment: "Bounced"
    t.integer "country_id", comment: "Country"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mail_mass_mailing_contact_list_rel", id: false, comment: "RELATION BETWEEN mail_mass_mailing_contact AND mail_mass_mailing_list", force: :cascade do |t|
    t.integer "contact_id", null: false
    t.integer "list_id", null: false
    t.index ["contact_id", "list_id"], name: "mail_mass_mailing_contact_list_rel_contact_id_list_id_key", unique: true
    t.index ["contact_id"], name: "mail_mass_mailing_contact_list_rel_contact_id_idx"
    t.index ["list_id"], name: "mail_mass_mailing_contact_list_rel_list_id_idx"
  end

  create_table "mail_mass_mailing_contact_res_partner_category_rel", id: false, comment: "RELATION BETWEEN mail_mass_mailing_contact AND res_partner_category", force: :cascade do |t|
    t.integer "mail_mass_mailing_contact_id", null: false
    t.integer "res_partner_category_id", null: false
    t.index ["mail_mass_mailing_contact_id", "res_partner_category_id"], name: "mail_mass_mailing_contact_res_mail_mass_mailing_contact_id__key", unique: true
    t.index ["mail_mass_mailing_contact_id"], name: "mail_mass_mailing_contact_res__mail_mass_mailing_contact_id_idx"
    t.index ["res_partner_category_id"], name: "mail_mass_mailing_contact_res_partn_res_partner_category_id_idx"
  end

  create_table "mail_mass_mailing_list", id: :serial, comment: "Mailing List", force: :cascade do |t|
    t.string "name", null: false, comment: "Mailing List"
    t.boolean "active", comment: "Active"
    t.datetime "create_date", comment: "Creation Date"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.text "popup_content", comment: "Website Popup Content"
    t.string "popup_redirect_url", comment: "Website Popup Redirect URL"
  end

  create_table "mail_mass_mailing_list_rel", id: false, comment: "RELATION BETWEEN mail_mass_mailing AND mail_mass_mailing_list", force: :cascade do |t|
    t.integer "mail_mass_mailing_id", null: false
    t.integer "mail_mass_mailing_list_id", null: false
    t.index ["mail_mass_mailing_id", "mail_mass_mailing_list_id"], name: "mail_mass_mailing_list_rel_mail_mass_mailing_id_mail_mass_m_key", unique: true
    t.index ["mail_mass_mailing_id"], name: "mail_mass_mailing_list_rel_mail_mass_mailing_id_idx"
    t.index ["mail_mass_mailing_list_id"], name: "mail_mass_mailing_list_rel_mail_mass_mailing_list_id_idx"
  end

  create_table "mail_mass_mailing_list_survey_mail_compose_message_rel", id: false, comment: "RELATION BETWEEN survey_mail_compose_message AND mail_mass_mailing_list", force: :cascade do |t|
    t.integer "survey_mail_compose_message_id", null: false
    t.integer "mail_mass_mailing_list_id", null: false
    t.index ["mail_mass_mailing_list_id"], name: "mail_mass_mailing_list_survey_mai_mail_mass_mailing_list_id_idx"
    t.index ["survey_mail_compose_message_id", "mail_mass_mailing_list_id"], name: "mail_mass_mailing_list_survey_survey_mail_compose_message_i_key", unique: true
    t.index ["survey_mail_compose_message_id"], name: "mail_mass_mailing_list_survey_survey_mail_compose_message_i_idx"
  end

  create_table "mail_mass_mailing_stage", id: :serial, comment: "Mass Mailing Campaign Stage", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mail_mass_mailing_tag", id: :serial, comment: "Mass Mailing Tag", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "mail_mass_mailing_tag_name_uniq", unique: true
  end

  create_table "mail_mass_mailing_tag_rel", id: false, comment: "RELATION BETWEEN mail_mass_mailing_campaign AND mail_mass_mailing_tag", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "campaign_id", null: false
    t.index ["campaign_id"], name: "mail_mass_mailing_tag_rel_campaign_id_idx"
    t.index ["tag_id", "campaign_id"], name: "mail_mass_mailing_tag_rel_tag_id_campaign_id_key", unique: true
    t.index ["tag_id"], name: "mail_mass_mailing_tag_rel_tag_id_idx"
  end

  create_table "mail_mass_mailing_test", id: :serial, comment: "Sample Mail Wizard", force: :cascade do |t|
    t.string "email_to", null: false, comment: "Recipients"
    t.integer "mass_mailing_id", null: false, comment: "Mailing"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mail_message", id: :serial, comment: "Message", force: :cascade do |t|
    t.string "subject", comment: "Subject"
    t.datetime "date", comment: "Date"
    t.text "body", comment: "Contents"
    t.integer "parent_id", comment: "Parent Message"
    t.string "model", comment: "Related Document Model"
    t.integer "res_id", comment: "Related Document ID"
    t.string "record_name", comment: "Message Record Name"
    t.string "message_type", null: false, comment: "Type"
    t.integer "subtype_id", comment: "Subtype"
    t.integer "mail_activity_type_id", comment: "Mail Activity Type"
    t.string "email_from", comment: "From"
    t.integer "author_id", comment: "Author"
    t.boolean "no_auto_thread", comment: "No threading for answers"
    t.string "message_id", comment: "Message-Id"
    t.string "reply_to", comment: "Reply-To"
    t.integer "mail_server_id", comment: "Outgoing mail server"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "website_published", comment: "Published"
    t.float "rating_value", comment: "Rating Value"
    t.index ["author_id"], name: "mail_message_author_id_index"
    t.index ["mail_activity_type_id"], name: "mail_message_mail_activity_type_id_index"
    t.index ["message_id"], name: "mail_message_message_id_index"
    t.index ["model", "res_id"], name: "mail_message_model_res_id_idx"
    t.index ["model"], name: "mail_message_model_index"
    t.index ["parent_id"], name: "mail_message_parent_id_index"
    t.index ["res_id"], name: "mail_message_res_id_index"
    t.index ["subtype_id"], name: "mail_message_subtype_id_index"
  end

  create_table "mail_message_mail_channel_rel", id: false, comment: "RELATION BETWEEN mail_message AND mail_channel", force: :cascade do |t|
    t.integer "mail_message_id", null: false
    t.integer "mail_channel_id", null: false
    t.index ["mail_channel_id"], name: "mail_message_mail_channel_rel_mail_channel_id_idx"
    t.index ["mail_message_id", "mail_channel_id"], name: "mail_message_mail_channel_rel_mail_message_id_mail_channel__key", unique: true
    t.index ["mail_message_id"], name: "mail_message_mail_channel_rel_mail_message_id_idx"
  end

  create_table "mail_message_res_partner_needaction_rel", id: :serial, comment: "Message Notifications", force: :cascade do |t|
    t.integer "mail_message_id", null: false, comment: "Message"
    t.integer "res_partner_id", null: false, comment: "Needaction Recipient"
    t.boolean "is_read", comment: "Is Read"
    t.boolean "is_email", comment: "Sent by Email"
    t.string "email_status", comment: "Email Status"
    t.index ["email_status"], name: "mail_message_res_partner_needaction_rel_email_status_index"
    t.index ["is_email"], name: "mail_message_res_partner_needaction_rel_is_email_index"
    t.index ["is_read"], name: "mail_message_res_partner_needaction_rel_is_read_index"
    t.index ["mail_message_id"], name: "mail_message_res_partner_needaction_rel_mail_message_id_index"
    t.index ["res_partner_id", "is_read", "email_status", "mail_message_id"], name: "mail_notification_res_partner_id_is_read_email_status_mail_mess"
    t.index ["res_partner_id"], name: "mail_message_res_partner_needaction_rel_res_partner_id_index"
  end

  create_table "mail_message_res_partner_rel", id: false, comment: "RELATION BETWEEN mail_message AND res_partner", force: :cascade do |t|
    t.integer "mail_message_id", null: false
    t.integer "res_partner_id", null: false
    t.index ["mail_message_id", "res_partner_id"], name: "mail_message_res_partner_rel_mail_message_id_res_partner_id_key", unique: true
    t.index ["mail_message_id"], name: "mail_message_res_partner_rel_mail_message_id_idx"
    t.index ["res_partner_id"], name: "mail_message_res_partner_rel_res_partner_id_idx"
  end

  create_table "mail_message_res_partner_starred_rel", id: false, comment: "RELATION BETWEEN mail_message AND res_partner", force: :cascade do |t|
    t.integer "mail_message_id", null: false
    t.integer "res_partner_id", null: false
    t.index ["mail_message_id", "res_partner_id"], name: "mail_message_res_partner_star_mail_message_id_res_partner_i_key", unique: true
    t.index ["mail_message_id"], name: "mail_message_res_partner_starred_rel_mail_message_id_idx"
    t.index ["res_partner_id"], name: "mail_message_res_partner_starred_rel_res_partner_id_idx"
  end

  create_table "mail_message_subtype", id: :serial, comment: "Message subtypes", force: :cascade do |t|
    t.string "name", null: false, comment: "Message Type"
    t.text "description", comment: "Description"
    t.boolean "internal", comment: "Internal Only"
    t.integer "parent_id", comment: "Parent"
    t.string "relation_field", comment: "Relation field"
    t.string "res_model", comment: "Model"
    t.boolean "default", comment: "Default"
    t.integer "sequence", comment: "Sequence"
    t.boolean "hidden", comment: "Hidden"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mail_shortcode", id: :serial, comment: "Canned Response / Shortcode", force: :cascade do |t|
    t.string "source", null: false, comment: "Shortcut"
    t.string "unicode_source", comment: "Unicode Character"
    t.text "substitution", null: false, comment: "Substitution"
    t.string "description", comment: "Description"
    t.string "shortcode_type", null: false, comment: "Shortcode Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["source"], name: "mail_shortcode_source_index"
    t.index ["substitution"], name: "mail_shortcode_substitution_index"
  end

  create_table "mail_template", id: :serial, comment: "Email Templates", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "model_id", comment: "Applies to"
    t.string "model", comment: "Related Document Model"
    t.string "lang", comment: "Language"
    t.boolean "user_signature", comment: "Add Signature"
    t.string "subject", comment: "Subject"
    t.string "email_from", comment: "From"
    t.boolean "use_default_to", comment: "Default recipients"
    t.string "email_to", comment: "To (Emails)"
    t.string "partner_to", comment: "To (Partners)"
    t.string "email_cc", comment: "Cc"
    t.string "reply_to", comment: "Reply-To"
    t.integer "mail_server_id", comment: "Outgoing Mail Server"
    t.text "body_html", comment: "Body"
    t.string "report_name", comment: "Report Filename"
    t.integer "report_template", comment: "Optional report to print and attach"
    t.integer "ref_ir_act_window", comment: "Sidebar action"
    t.boolean "auto_delete", comment: "Auto Delete"
    t.integer "model_object_field", comment: "Field"
    t.integer "sub_object", comment: "Sub-model"
    t.integer "sub_model_object_field", comment: "Sub-field"
    t.string "null_value", comment: "Default Value"
    t.string "copyvalue", comment: "Placeholder Expression"
    t.string "scheduled_date", comment: "Scheduled Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["model"], name: "mail_template_model_index"
  end

  create_table "mail_test", id: :serial, comment: "Test Mail Model", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Name"
    t.text "description", comment: "Description"
    t.integer "alias_id", null: false, comment: "Alias"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mail_test_simple", id: :serial, comment: "Test Simple Chatter Record", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.string "email_from", comment: "Email From"
    t.text "description", comment: "Description"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mail_tracking_email", id: :serial, comment: "MailTracking email", force: :cascade do |t|
    t.string "name", comment: "Subject"
    t.string "display_name", comment: "Display name"
    t.decimal "timestamp", comment: "UTC timestamp"
    t.datetime "time", comment: "Time"
    t.date "date", comment: "Date"
    t.integer "mail_message_id", comment: "Message"
    t.integer "mail_id", comment: "Email"
    t.integer "partner_id", comment: "Partner"
    t.string "recipient", comment: "Recipient email"
    t.string "recipient_address", comment: "Recipient email address"
    t.string "sender", comment: "Sender email"
    t.string "state", comment: "State"
    t.string "error_smtp_server", comment: "Error SMTP server"
    t.string "error_type", comment: "Error type"
    t.string "error_description", comment: "Error description"
    t.string "bounce_type", comment: "Bounce type"
    t.string "bounce_description", comment: "Bounce description"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["mail_message_id"], name: "mail_tracking_email_mail_message_id_index"
    t.index ["name"], name: "mail_tracking_email_name_index"
    t.index ["recipient_address"], name: "mail_tracking_email_recipient_address_index"
    t.index ["state"], name: "mail_tracking_email_state_index"
    t.index ["time"], name: "mail_tracking_email_time_index"
  end

  create_table "mail_tracking_event", id: :serial, comment: "MailTracking event", force: :cascade do |t|
    t.string "recipient", comment: "Recipient"
    t.string "recipient_address", comment: "Recipient email address"
    t.decimal "timestamp", comment: "UTC timestamp"
    t.datetime "time", comment: "Time"
    t.date "date", comment: "Date"
    t.integer "tracking_email_id", null: false, comment: "Message"
    t.string "event_type", comment: "Event type"
    t.string "smtp_server", comment: "SMTP server"
    t.string "url", comment: "Clicked URL"
    t.string "ip", comment: "User IP"
    t.string "user_agent", comment: "User agent"
    t.boolean "mobile", comment: "Is mobile?"
    t.string "os_family", comment: "Operating system family"
    t.string "ua_family", comment: "User agent family"
    t.string "ua_type", comment: "User agent type"
    t.integer "user_country_id", comment: "User country"
    t.string "error_type", comment: "Error type"
    t.string "error_description", comment: "Error description"
    t.text "error_details", comment: "Error details"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["recipient_address"], name: "mail_tracking_event_recipient_address_index"
    t.index ["tracking_email_id"], name: "mail_tracking_event_tracking_email_id_index"
  end

  create_table "mail_tracking_value", id: :serial, comment: "Mail Tracking Value", force: :cascade do |t|
    t.string "field", null: false, comment: "Changed Field"
    t.string "field_desc", null: false, comment: "Field Description"
    t.string "field_type", comment: "Field Type"
    t.integer "old_value_integer", comment: "Old Value Integer"
    t.float "old_value_float", comment: "Old Value Float"
    t.float "old_value_monetary", comment: "Old Value Monetary"
    t.string "old_value_char", comment: "Old Value Char"
    t.text "old_value_text", comment: "Old Value Text"
    t.datetime "old_value_datetime", comment: "Old Value DateTime"
    t.integer "new_value_integer", comment: "New Value Integer"
    t.float "new_value_float", comment: "New Value Float"
    t.float "new_value_monetary", comment: "New Value Monetary"
    t.string "new_value_char", comment: "New Value Char"
    t.text "new_value_text", comment: "New Value Text"
    t.datetime "new_value_datetime", comment: "New Value Datetime"
    t.integer "mail_message_id", null: false, comment: "Message ID"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["mail_message_id"], name: "mail_tracking_value_mail_message_id_index"
  end

  create_table "mail_wizard_invite", id: :serial, comment: "Invite wizard", force: :cascade do |t|
    t.string "res_model", null: false, comment: "Related Document Model"
    t.integer "res_id", comment: "Related Document ID"
    t.text "message", comment: "Message"
    t.boolean "send_mail", comment: "Send Email"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["res_id"], name: "mail_wizard_invite_res_id_index"
    t.index ["res_model"], name: "mail_wizard_invite_res_model_index"
  end

  create_table "mail_wizard_invite_res_partner_rel", id: false, comment: "RELATION BETWEEN mail_wizard_invite AND res_partner", force: :cascade do |t|
    t.integer "mail_wizard_invite_id", null: false
    t.integer "res_partner_id", null: false
    t.index ["mail_wizard_invite_id", "res_partner_id"], name: "mail_wizard_invite_res_partne_mail_wizard_invite_id_res_par_key", unique: true
    t.index ["mail_wizard_invite_id"], name: "mail_wizard_invite_res_partner_rel_mail_wizard_invite_id_idx"
    t.index ["res_partner_id"], name: "mail_wizard_invite_res_partner_rel_res_partner_id_idx"
  end

  create_table "maintenance_equipment", id: :serial, comment: "Equipment", force: :cascade do |t|
    t.string "name", null: false, comment: "Equipment Name"
    t.boolean "active", comment: "Active"
    t.integer "technician_user_id", comment: "Technician"
    t.integer "owner_user_id", comment: "Owner"
    t.integer "category_id", comment: "Equipment Category"
    t.integer "partner_id", comment: "Vendor"
    t.string "partner_ref", comment: "Vendor Reference"
    t.string "location", comment: "Location"
    t.string "model", comment: "Model"
    t.string "serial_no", comment: "Serial Number"
    t.date "assign_date", comment: "Assigned Date"
    t.float "cost", comment: "Cost"
    t.text "note", comment: "Note"
    t.date "warranty", comment: "Warranty"
    t.integer "color", comment: "Color Index"
    t.date "scrap_date", comment: "Scrap Date"
    t.integer "maintenance_count", comment: "Maintenance"
    t.integer "maintenance_open_count", comment: "Current Maintenance"
    t.integer "period", comment: "Days between each preventive maintenance"
    t.date "next_action_date", comment: "Date of the next preventive maintenance"
    t.integer "maintenance_team_id", comment: "Maintenance Team"
    t.float "maintenance_duration", comment: "Maintenance Duration"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "employee_id", comment: "Assigned to Employee"
    t.integer "department_id", comment: "Assigned to Department"
    t.string "equipment_assign_to", null: false, comment: "Used By"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.string "code", comment: "Code"
    t.integer "status_id", comment: "Status"
    t.string "status_name", comment: "Status name"
    t.integer "location_id", null: false, comment: "Location"
    t.index ["serial_no"], name: "maintenance_equipment_serial_no", unique: true
  end

  create_table "maintenance_equipment_category", id: :serial, comment: "Asset Category", force: :cascade do |t|
    t.string "name", null: false, comment: "Category Name"
    t.integer "technician_user_id", comment: "Responsible"
    t.integer "color", comment: "Color Index"
    t.text "note", comment: "Comments"
    t.integer "alias_id", null: false, comment: "Alias"
    t.boolean "fold", comment: "Folded in Maintenance Pipe"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "sequence_prefix", comment: "Sequence Prefix"
    t.integer "sequence_id", comment: "Entry Sequence"
    t.integer "parent_id", comment: "Parent Category"
    t.integer "parent_left", comment: "Left Parent"
    t.integer "parent_right", comment: "Right Parent"
    t.index ["parent_id"], name: "maintenance_equipment_category_parent_id_index"
    t.index ["parent_left"], name: "maintenance_equipment_category_parent_left_index"
    t.index ["parent_right"], name: "maintenance_equipment_category_parent_right_index"
  end

  create_table "maintenance_equipment_category_maintenance_equipment_status_rel", id: false, comment: "RELATION BETWEEN maintenance_equipment_status AND maintenance_equipment_category", force: :cascade do |t|
    t.integer "maintenance_equipment_status_id", null: false
    t.integer "maintenance_equipment_category_id", null: false
    t.index ["maintenance_equipment_category_id"], name: "maintenance_equipment_categor_maintenance_equipment_categor_idx"
    t.index ["maintenance_equipment_status_id", "maintenance_equipment_category_id"], name: "maintenance_equipment_categor_maintenance_equipment_status__key", unique: true
    t.index ["maintenance_equipment_status_id"], name: "maintenance_equipment_categor_maintenance_equipment_status__idx"
  end

  create_table "maintenance_equipment_location", id: :serial, comment: "Equipment Location", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "company_id", comment: "Company"
    t.boolean "is_scrap", comment: "Scrap Location"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "maintenance_equipment_maintenance_equipment_move_rel", id: false, comment: "RELATION BETWEEN maintenance_equipment_move AND maintenance_equipment", force: :cascade do |t|
    t.integer "maintenance_equipment_move_id", null: false
    t.integer "maintenance_equipment_id", null: false
    t.index ["maintenance_equipment_id"], name: "maintenance_equipment_maintenance__maintenance_equipment_id_idx"
    t.index ["maintenance_equipment_move_id", "maintenance_equipment_id"], name: "maintenance_equipment_mainten_maintenance_equipment_move_id_key", unique: true
    t.index ["maintenance_equipment_move_id"], name: "maintenance_equipment_mainten_maintenance_equipment_move_id_idx"
  end

  create_table "maintenance_equipment_move", id: :serial, comment: "Equipment Moves", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Move Number"
    t.string "state", comment: "Status"
    t.integer "move_type_id", null: false, comment: "Move Type"
    t.integer "from_location_id", null: false, comment: "From Location"
    t.integer "to_location_id", comment: "To Location"
    t.datetime "date", null: false, comment: "Date"
    t.datetime "return_date", comment: "Return Date"
    t.text "note", comment: "Description"
    t.boolean "is_transfer", comment: "Is Transfer"
    t.boolean "is_internal", comment: "Is Internal"
    t.integer "user_id", null: false, comment: "Equipment User"
    t.integer "session_id", comment: "Session"
    t.datetime "actual_return_date", comment: "Actual Return Date"
    t.string "return_state", comment: "Return State"
    t.text "return_note", comment: "Return Description"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "maintenance_equipment_move_type", id: :serial, comment: "maintenance.equipment.move.type", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.boolean "is_transfer", comment: "Is Transfer"
    t.boolean "is_internal", comment: "Is Internal"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "maintenance_equipment_status", id: :serial, comment: "Maintenance Equipment Status", force: :cascade do |t|
    t.boolean "active", comment: "Active"
    t.string "name", comment: "Name"
    t.text "note", comment: "Notes"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "maintenance_equipment_tag", id: :serial, comment: "Maintenance Equipment Tag", force: :cascade do |t|
    t.string "name", null: false, comment: "Equipment Tag"
    t.integer "color", comment: "Color Index (0-15)"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "maintenance_equipment_tag_name_uniq", unique: true
  end

  create_table "maintenance_request", id: :serial, comment: "Maintenance Requests", force: :cascade do |t|
    t.string "name", null: false, comment: "Subjects"
    t.text "description", comment: "Description"
    t.date "request_date", comment: "Request Date"
    t.integer "owner_user_id", comment: "Created by"
    t.integer "category_id", comment: "Category"
    t.integer "equipment_id", comment: "Equipment"
    t.integer "technician_user_id", comment: "Owner"
    t.integer "stage_id", comment: "Stage"
    t.string "priority", comment: "Priority"
    t.integer "color", comment: "Color Index"
    t.date "close_date", comment: "Close Date"
    t.string "kanban_state", null: false, comment: "Kanban State"
    t.boolean "archive", comment: "Archive"
    t.string "maintenance_type", comment: "Maintenance Type"
    t.datetime "schedule_date", comment: "Scheduled Date"
    t.integer "maintenance_team_id", null: false, comment: "Team"
    t.float "duration", comment: "Duration"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "employee_id", comment: "Employee"
    t.integer "department_id", comment: "Department"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.string "code", comment: "Code"
    t.index ["equipment_id"], name: "maintenance_request_equipment_id_index"
  end

  create_table "maintenance_stage", id: :serial, comment: "Maintenance Stage", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "sequence", comment: "Sequence"
    t.boolean "fold", comment: "Folded in Maintenance Pipe"
    t.boolean "done", comment: "Request Done"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "button_class", comment: "Button Class"
  end

  create_table "maintenance_stage_next_stage", id: false, comment: "RELATION BETWEEN maintenance_stage AND maintenance_stage", force: :cascade do |t|
    t.integer "stage_id", null: false
    t.integer "next_stage_id", null: false
    t.index ["next_stage_id"], name: "maintenance_stage_next_stage_next_stage_id_idx"
    t.index ["stage_id", "next_stage_id"], name: "maintenance_stage_next_stage_stage_id_next_stage_id_key", unique: true
    t.index ["stage_id"], name: "maintenance_stage_next_stage_stage_id_idx"
  end

  create_table "maintenance_team", id: :serial, comment: "Maintenance Teams", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "active", comment: "Active"
    t.integer "user_id", comment: "Team Leader"
    t.text "description", comment: "Description"
    t.string "code_prefix", comment: "Prefix for Team Reference"
    t.integer "sequence_id", comment: "Team Sequence"
  end

  create_table "maintenance_team_users_rel", id: false, comment: "RELATION BETWEEN maintenance_team AND res_users", force: :cascade do |t|
    t.integer "maintenance_team_id", null: false
    t.integer "res_users_id", null: false
    t.index ["maintenance_team_id", "res_users_id"], name: "maintenance_team_users_rel_maintenance_team_id_res_users_id_key", unique: true
    t.index ["maintenance_team_id"], name: "maintenance_team_users_rel_maintenance_team_id_idx"
    t.index ["res_users_id"], name: "maintenance_team_users_rel_res_users_id_idx"
  end

  create_table "mass_editing_wizard", id: :serial, comment: "mass.editing.wizard", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "mass_mailing_ir_attachments_rel", id: false, comment: "RELATION BETWEEN mail_mass_mailing AND ir_attachment", force: :cascade do |t|
    t.integer "mass_mailing_id", null: false
    t.integer "attachment_id", null: false
    t.index ["attachment_id"], name: "mass_mailing_ir_attachments_rel_attachment_id_idx"
    t.index ["mass_mailing_id", "attachment_id"], name: "mass_mailing_ir_attachments_r_mass_mailing_id_attachment_id_key", unique: true
    t.index ["mass_mailing_id"], name: "mass_mailing_ir_attachments_rel_mass_mailing_id_idx"
  end

  create_table "mass_object", id: :serial, comment: "Mass Editing Object", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "model_id", null: false, comment: "Model"
    t.integer "ref_ir_act_window_id", comment: "Sidebar action"
    t.string "model_list", comment: "Model List"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "mass_object_name_index"
  end

  create_table "meeting_category_rel", id: false, comment: "RELATION BETWEEN calendar_event AND calendar_event_type", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "type_id", null: false
    t.index ["event_id", "type_id"], name: "meeting_category_rel_event_id_type_id_key", unique: true
    t.index ["event_id"], name: "meeting_category_rel_event_id_idx"
    t.index ["type_id"], name: "meeting_category_rel_type_id_idx"
  end

  create_table "merge_opportunity_rel", id: false, comment: "RELATION BETWEEN crm_merge_opportunity AND crm_lead", force: :cascade do |t|
    t.integer "merge_id", null: false
    t.integer "opportunity_id", null: false
    t.index ["merge_id", "opportunity_id"], name: "merge_opportunity_rel_merge_id_opportunity_id_key", unique: true
    t.index ["merge_id"], name: "merge_opportunity_rel_merge_id_idx"
    t.index ["opportunity_id"], name: "merge_opportunity_rel_opportunity_id_idx"
  end

  create_table "message_attachment_rel", id: false, comment: "RELATION BETWEEN mail_message AND ir_attachment", force: :cascade do |t|
    t.integer "message_id", null: false
    t.integer "attachment_id", null: false
    t.index ["attachment_id"], name: "message_attachment_rel_attachment_id_idx"
    t.index ["message_id", "attachment_id"], name: "message_attachment_rel_message_id_attachment_id_key", unique: true
    t.index ["message_id"], name: "message_attachment_rel_message_id_idx"
  end

  create_table "muk_autovacuum_rules", id: :serial, comment: "Auto Vacuum Rules", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "name", null: false, comment: "Name"
    t.boolean "active", comment: "Active"
    t.string "state", null: false, comment: "Rule Type"
    t.integer "sequence", null: false, comment: "Sequence"
    t.integer "model", null: false, comment: "Model"
    t.string "model_name", comment: "Model Name"
    t.integer "time_field", comment: "Time Field"
    t.string "time_type", comment: "Time Unit"
    t.integer "time", comment: "Time"
    t.string "size_type", comment: "Size Type"
    t.integer "size_parameter", comment: "System Parameter"
    t.string "size_order", comment: "Size Order"
    t.integer "size", comment: "Size"
    t.string "domain", comment: "Domain"
    t.text "code", comment: "Code"
    t.boolean "protect_starred", comment: "Protect Starred"
    t.boolean "only_inactive", comment: "Only Archived"
    t.boolean "only_attachments", comment: "Only Attachments"
  end

  create_table "muk_web_client_notification_send_notifications", id: :serial, comment: "muk_web_client_notification.send_notifications", force: :cascade do |t|
    t.string "type", null: false, comment: "Type"
    t.string "title", null: false, comment: "Title"
    t.text "message", null: false, comment: "Message"
    t.boolean "sticky", comment: "Sticky"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "muk_web_client_notification_user_rel", id: false, comment: "RELATION BETWEEN muk_web_client_notification_send_notifications AND res_users", force: :cascade do |t|
    t.integer "wizard_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "muk_web_client_notification_user_rel_user_id_idx"
    t.index ["wizard_id", "user_id"], name: "muk_web_client_notification_user_rel_wizard_id_user_id_key", unique: true
    t.index ["wizard_id"], name: "muk_web_client_notification_user_rel_wizard_id_idx"
  end

  create_table "note_note", id: :serial, comment: "Note", force: :cascade do |t|
    t.text "name", comment: "Note Summary"
    t.integer "user_id", comment: "Owner"
    t.text "memo", comment: "Note Content"
    t.integer "sequence", comment: "Sequence"
    t.boolean "open", comment: "Active"
    t.date "date_done", comment: "Date done"
    t.integer "color", comment: "Color Index"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
  end

  create_table "note_stage", id: :serial, comment: "Note Stage", force: :cascade do |t|
    t.string "name", null: false, comment: "Stage Name"
    t.integer "sequence", comment: "Sequence"
    t.integer "user_id", null: false, comment: "Owner"
    t.boolean "fold", comment: "Folded by Default"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "note_stage_rel", id: false, comment: "RELATION BETWEEN note_note AND note_stage", force: :cascade do |t|
    t.integer "note_id", null: false
    t.integer "stage_id", null: false
    t.index ["note_id", "stage_id"], name: "note_stage_rel_note_id_stage_id_key", unique: true
    t.index ["note_id"], name: "note_stage_rel_note_id_idx"
    t.index ["stage_id"], name: "note_stage_rel_stage_id_idx"
  end

  create_table "note_tag", id: :serial, comment: "Note Tag", force: :cascade do |t|
    t.string "name", null: false, comment: "Tag Name"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "note_tag_name_uniq", unique: true
  end

  create_table "note_tags_rel", id: false, comment: "RELATION BETWEEN note_note AND note_tag", force: :cascade do |t|
    t.integer "note_id", null: false
    t.integer "tag_id", null: false
    t.index ["note_id", "tag_id"], name: "note_tags_rel_note_id_tag_id_key", unique: true
    t.index ["note_id"], name: "note_tags_rel_note_id_idx"
    t.index ["tag_id"], name: "note_tags_rel_tag_id_idx"
  end

  create_table "op_activity", id: :serial, comment: "op.activity", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "student_id", null: false, comment: "Student"
    t.integer "faculty_id", comment: "Faculty"
    t.integer "type_id", comment: "Activity Type"
    t.text "description", comment: "Description"
    t.date "date", comment: "Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_activity_type", id: :serial, comment: "op.activity.type", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_admission", id: :serial, comment: "Admission", force: :cascade do |t|
    t.string "name", null: false, comment: "First Name"
    t.string "middle_name", limit: 128, comment: "Middle Name"
    t.string "last_name", limit: 128, null: false, comment: "Last Name"
    t.integer "title", comment: "Title"
    t.string "application_number", limit: 16, null: false, comment: "Application Number"
    t.date "admission_date", comment: "Admission Date"
    t.datetime "application_date", null: false, comment: "Application Date"
    t.date "birth_date", null: false, comment: "Birth Date"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.string "street", limit: 256, comment: "Street"
    t.string "street2", limit: 256, comment: "Street2"
    t.string "phone", limit: 16, comment: "Phone"
    t.string "mobile", limit: 16, comment: "Mobile"
    t.string "email", limit: 256, comment: "Email"
    t.string "city", limit: 64, comment: "City"
    t.string "zip", limit: 8, comment: "Zip"
    t.integer "state_id", comment: "States"
    t.integer "country_id", comment: "Country"
    t.float "fees", comment: "Fees"
    t.binary "image", comment: "image"
    t.string "state", comment: "State"
    t.date "due_date", comment: "Due Date"
    t.integer "prev_institute_id", comment: "Previous Institute"
    t.integer "prev_course_id", comment: "Previous Course"
    t.string "prev_result", limit: 256, comment: "Previous Result"
    t.string "family_business", limit: 256, comment: "Family Business"
    t.float "family_income", comment: "Family Income"
    t.string "gender", null: false, comment: "Gender"
    t.integer "student_id", comment: "Student"
    t.integer "nbr", comment: "No of Admission"
    t.integer "register_id", null: false, comment: "Admission Register"
    t.integer "partner_id", comment: "Partner"
    t.boolean "is_student", comment: "Is Already Student"
    t.integer "fees_term_id", comment: "Fees Term"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "company_id", comment: "Company"
    t.string "full_name", comment: "Full name"
    t.string "note", comment: "Sale Order"
    t.integer "sale_order_id", comment: "Sale Order"
    t.integer "sale_order_line_id", comment: "Sale Order Line"
    t.string "admission_type", comment: "Type"
    t.datetime "actual_start_date", comment: "Actual Start Date"
    t.datetime "actual_end_date", comment: "Actual End Date"
    t.float "retain_rate", comment: "Retention Rate %"
    t.boolean "retained", comment: "Retained"
    t.string "admission_mode", comment: "Mode"
    t.boolean "last_subject", comment: "Last Subject Sessions Created?"
    t.boolean "last_subject_sessions_created", comment: "Last Subject Sessions Created?"
    t.integer "claim_id", comment: "Claim"
  end

  create_table "op_admission_register", id: :serial, comment: "Admission Register", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.datetime "start_date", null: false, comment: "Start Date"
    t.datetime "end_date", null: false, comment: "End Date"
    t.integer "course_id", comment: "Course"
    t.integer "min_count", comment: "Minimum No. of Admission"
    t.integer "max_count", comment: "Maximum No. of Admission"
    t.integer "product_id", comment: "Product"
    t.string "state", comment: "Status"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "company_id", comment: "Company"
    t.integer "batch_id", comment: "Batch"
  end

  create_table "op_admission_student_test_rel", id: false, comment: "RELATION BETWEEN op_admission AND student_test", force: :cascade do |t|
    t.integer "op_admission_id", null: false
    t.integer "student_test_id", null: false
    t.index ["op_admission_id", "student_test_id"], name: "op_admission_student_test_rel_op_admission_id_student_test__key", unique: true
    t.index ["op_admission_id"], name: "op_admission_student_test_rel_op_admission_id_idx"
    t.index ["student_test_id"], name: "op_admission_student_test_rel_student_test_id_idx"
  end

  create_table "op_admission_subject_rel", id: false, comment: "RELATION BETWEEN op_admission AND op_subject", force: :cascade do |t|
    t.integer "admission_id", null: false
    t.integer "subject_id", null: false
    t.index ["admission_id", "subject_id"], name: "op_admission_subject_rel_admission_id_subject_id_key", unique: true
    t.index ["admission_id"], name: "op_admission_subject_rel_admission_id_idx"
    t.index ["subject_id"], name: "op_admission_subject_rel_subject_id_idx"
  end

  create_table "op_all_student", id: :serial, comment: "op.all.student", force: :cascade do |t|
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_all_student_op_student_rel", id: false, comment: "RELATION BETWEEN op_all_student AND op_student", force: :cascade do |t|
    t.integer "op_all_student_id", null: false
    t.integer "op_student_id", null: false
    t.index ["op_all_student_id", "op_student_id"], name: "op_all_student_op_student_rel_op_all_student_id_op_student__key", unique: true
    t.index ["op_all_student_id"], name: "op_all_student_op_student_rel_op_all_student_id_idx"
    t.index ["op_student_id"], name: "op_all_student_op_student_rel_op_student_id_idx"
  end

  create_table "op_asset", id: :serial, comment: "op.asset", force: :cascade do |t|
    t.integer "asset_id", comment: "Asset"
    t.integer "product_id", null: false, comment: "Product"
    t.string "code", limit: 256, comment: "Code"
    t.float "product_uom_qty", null: false, comment: "Quantity"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_assignment", id: :serial, comment: "Assignment", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.integer "subject_id", null: false, comment: "Subject"
    t.integer "faculty_id", null: false, comment: "Faculty"
    t.integer "assignment_type_id", null: false, comment: "Assignment Type"
    t.float "marks", null: false, comment: "Marks"
    t.text "description", null: false, comment: "Description"
    t.string "state", null: false, comment: "State"
    t.datetime "issued_date", null: false, comment: "Issued Date"
    t.datetime "submission_date", null: false, comment: "Submission Date"
    t.integer "reviewer", comment: "Reviewer"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_assignment_op_student_rel", id: false, comment: "RELATION BETWEEN op_assignment AND op_student", force: :cascade do |t|
    t.integer "op_assignment_id", null: false
    t.integer "op_student_id", null: false
    t.index ["op_assignment_id", "op_student_id"], name: "op_assignment_op_student_rel_op_assignment_id_op_student_id_key", unique: true
    t.index ["op_assignment_id"], name: "op_assignment_op_student_rel_op_assignment_id_idx"
    t.index ["op_student_id"], name: "op_assignment_op_student_rel_op_student_id_idx"
  end

  create_table "op_assignment_sub_line", id: :serial, comment: "Assignment Submission", force: :cascade do |t|
    t.integer "assignment_id", null: false, comment: "Assignment"
    t.integer "student_id", null: false, comment: "Student"
    t.text "description", comment: "Description"
    t.string "state", comment: "State"
    t.datetime "submission_date", null: false, comment: "Submission Date"
    t.float "marks", comment: "Marks"
    t.text "note", comment: "Note"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_assignment_type", id: :serial, comment: "op.assignment.type", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "op_assignment_type_unique_assignment_type_code", unique: true
  end

  create_table "op_attendance_line", id: :serial, comment: "op.attendance.line", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "attendance_id", null: false, comment: "Attendance Sheet"
    t.integer "student_id", null: false, comment: "Student"
    t.boolean "present", comment: "Present ?"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.string "remark", limit: 256, comment: "Remark"
    t.date "attendance_date", comment: "Date"
    t.integer "register_id", comment: "Register"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "session_id", comment: "Session"
    t.integer "company_id", comment: "Company"
    t.string "knowledge1", comment: "Khả năng tiếp thu kiến thức bài học mới"
    t.string "knowledge2", comment: "Khả năng sáng tạo, phát triển ý tưởng bài học"
    t.string "knowledge3", comment: "Khả năng tiếp thu kiến thức bài học mới"
    t.string "knowledge4", comment: "Hoàn thành bài tập về nhà"
    t.string "attitude1", comment: "Khả năng tập trung, chú ý nghe giảng"
    t.string "attitude2", comment: "Tinh thần phát biểu, xây dựng bài học"
    t.string "attitude3", comment: "Tham gia các hoạt động trong lớp"
    t.string "skill1", comment: "Khả năng làm việc nhóm"
    t.string "skill2", comment: "Kỹ năng thuyết trình"
    t.text "note", comment: "Nhận xét khác"
    t.text "picture_link", comment: "Link ảnh"
    t.text "product_link", comment: "Link sản phẩm"
    t.string "state_evaluate", comment: "Lựa chọn đánh giá"
    t.string "category_finish", comment: "Tốc độ hoàn thành các hoạt động trong lớp"
    t.string "category_old_ideas", comment: "Mức độ học sinh vận dụng các kiến thức cũ trong bài học mới"
    t.string "category_skill", comment: "Mức độ học sinh có thể áp dụng các kỹ năng từ các bài đã học trong bài học mới"
    t.string "category_creation", comment: "Mức độ sáng tạo trong các buổi học"
    t.string "category_complete", comment: "Mức độ học sinh hoàn thành các hoạt động trong lớp"
    t.string "category_presentation", comment: "Khả năng thuyết trình"
    t.string "category_working_group", comment: "Khả năng làm việc nhóm"
    t.string "category_complete_project", comment: "Độ hoàn thiện dự án cuối khóa"
    t.string "category_awareness", comment: "Ý thức học tập, Khả năng tập trung, chú ý nghe giảng"
    t.string "category_stated", comment: "Tinh thần phát biểu, xây dựng bài học "
    t.string "category_take_initiative", comment: "Mức độ chủ động tham gia các hoạt động trong lớp"
    t.text "note_1", comment: "Nhận xét khác"
    t.text "note_2", comment: "Nhận xét khác"
    t.text "product_link_1", comment: "Link sản phẩm"
    t.text "product_link_2", comment: "Link sản phẩm"
  end

  create_table "op_attendance_register", id: :serial, comment: "op.attendance.register", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Name"
    t.string "code", comment: "Code"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.integer "subject_id", comment: "Subject"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "op_attendance_register_unique_attendance_register_code", unique: true
  end

  create_table "op_attendance_sheet", id: :serial, comment: "op.attendance.sheet", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Name"
    t.integer "register_id", comment: "Register"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "session_id", comment: "Session"
    t.date "attendance_date", comment: "Date"
    t.integer "faculty_id", comment: "Faculty"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "faculty_name", comment: "Faculty"
    t.string "state", comment: "State"
    t.integer "tutors_id", comment: "Tutors"
    t.integer "company_id", comment: "Company"
    t.text "note", comment: "Target"
    t.integer "subject_id", comment: "Subject"
    t.string "exercise", comment: "Link bài tập về nhà"
    t.integer "lession_id", comment: "Lesson"
    t.text "picture_link", comment: "Link ảnh"
    t.index ["register_id", "session_id", "attendance_date"], name: "op_attendance_sheet_unique_register_sheet", unique: true
  end

  create_table "op_author", id: :serial, comment: "op.author", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "address", comment: "Address"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_author_op_media_rel", id: false, comment: "RELATION BETWEEN op_author AND op_media", force: :cascade do |t|
    t.integer "op_author_id", null: false
    t.integer "op_media_id", null: false
    t.index ["op_author_id", "op_media_id"], name: "op_author_op_media_rel_op_author_id_op_media_id_key", unique: true
    t.index ["op_author_id"], name: "op_author_op_media_rel_op_author_id_idx"
    t.index ["op_media_id"], name: "op_author_op_media_rel_op_media_id_idx"
  end

  create_table "op_badge_student", id: :serial, comment: "Gamification Student badge", force: :cascade do |t|
    t.integer "student_id", null: false, comment: "Student"
    t.integer "sender_id", comment: "Sender"
    t.integer "badge_id", null: false, comment: "Badge"
    t.text "comment", comment: "Comment"
    t.datetime "create_date", comment: "Created"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["badge_id"], name: "op_badge_student_badge_id_index"
    t.index ["student_id"], name: "op_badge_student_student_id_index"
  end

  create_table "op_badge_student_wizard", id: :serial, comment: "op.badge.student.wizard", force: :cascade do |t|
    t.integer "student_id", null: false, comment: "Student"
    t.integer "badge_id", null: false, comment: "Badge"
    t.text "comment", comment: "Comment"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_batch", id: :serial, comment: "op.batch", force: :cascade do |t|
    t.string "code", null: false, comment: "Code"
    t.string "name", null: false, comment: "Name"
    t.date "start_date", null: false, comment: "Start Date"
    t.date "end_date", null: false, comment: "End Date"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "company_id", comment: "Company"
    t.integer "type_id", comment: "Type"
    t.string "level", comment: "Level"
    t.integer "total", comment: "Total Students"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.string "select_place", comment: "Select Place"
    t.string "lang", comment: "Lang"
    t.string "select_type", comment: "Select Type"
    t.string "state", comment: "State"
    t.boolean "active", comment: "Active"
    t.integer "register_id", comment: "Admission Register"
    t.integer "sesion_per_week", comment: "Session per week"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.string "note_time", comment: "Giờ học dự kiến"
    t.text "lesson_link", comment: "Link bài tập"
    t.index ["code"], name: "op_batch_unique_batch_code", unique: true
  end

  create_table "op_batch_type", id: :serial, comment: "op.batch.type", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_board_affiliation", id: :serial, comment: "op.board.affiliation", force: :cascade do |t|
    t.string "name", comment: "Board Name"
    t.string "code", comment: "Code"
    t.text "note", comment: "Description"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_category", id: :serial, comment: "op.category", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "op_category_unique_category_code", unique: true
  end

  create_table "op_classroom", id: :serial, comment: "op.classroom", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "capacity", comment: "No of Person"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "center_id", comment: "Center"
    t.boolean "active", comment: "Active"
    t.index ["code"], name: "op_classroom_unique_classroom_code", unique: true
  end

  create_table "op_classroom_report_wizard", id: :serial, comment: "op.classroom.report_wizard", force: :cascade do |t|
    t.integer "center_id", comment: "Center"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "classroom_id", comment: "Classroom"
  end

  create_table "op_course", id: :serial, comment: "op.course", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "parent_id", comment: "Parent Course"
    t.string "section", null: false, comment: "Section"
    t.string "evaluation_type", null: false, comment: "Evaluation Type"
    t.float "max_unit_load", comment: "Maximum Unit Load"
    t.float "min_unit_load", comment: "Minimum Unit Load"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "fees_term_id", comment: "Fees Term"
    t.integer "company_id", comment: "Company"
    t.string "sequence_next", comment: "Mã số bắt đầu"
    t.integer "categ_id", comment: "Course Category"
    t.boolean "active", comment: "Active"
    t.index ["code"], name: "op_course_unique_course_code", unique: true
  end

  create_table "op_course_op_media_rel", id: false, comment: "RELATION BETWEEN op_media AND op_course", force: :cascade do |t|
    t.integer "op_media_id", null: false
    t.integer "op_course_id", null: false
    t.index ["op_course_id"], name: "op_course_op_media_rel_op_course_id_idx"
    t.index ["op_media_id", "op_course_id"], name: "op_course_op_media_rel_op_media_id_op_course_id_key", unique: true
    t.index ["op_media_id"], name: "op_course_op_media_rel_op_media_id_idx"
  end

  create_table "op_course_op_subject_rel", id: false, comment: "RELATION BETWEEN op_course AND op_subject", force: :cascade do |t|
    t.integer "op_course_id", null: false
    t.integer "op_subject_id", null: false
    t.index ["op_course_id", "op_subject_id"], name: "op_course_op_subject_rel_op_course_id_op_subject_id_key", unique: true
    t.index ["op_course_id"], name: "op_course_op_subject_rel_op_course_id_idx"
    t.index ["op_subject_id"], name: "op_course_op_subject_rel_op_subject_id_idx"
  end

  create_table "op_course_student_test_rel", id: false, comment: "RELATION BETWEEN student_test AND op_course", force: :cascade do |t|
    t.integer "student_test_id", null: false
    t.integer "op_course_id", null: false
    t.index ["op_course_id"], name: "op_course_student_test_rel_op_course_id_idx"
    t.index ["student_test_id", "op_course_id"], name: "op_course_student_test_rel_student_test_id_op_course_id_key", unique: true
    t.index ["student_test_id"], name: "op_course_student_test_rel_student_test_id_idx"
  end

  create_table "op_exam", id: :serial, comment: "Exam", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "session_id", comment: "Exam Session"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "subject_id", null: false, comment: "Subject"
    t.string "exam_code", null: false, comment: "Exam Code"
    t.datetime "start_time", null: false, comment: "Start Time"
    t.datetime "end_time", null: false, comment: "End Time"
    t.string "state", comment: "State"
    t.text "note", comment: "Note"
    t.string "name", null: false, comment: "Exam"
    t.integer "total_marks", null: false, comment: "Total Marks"
    t.integer "min_marks", null: false, comment: "Passing Marks"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["exam_code"], name: "op_exam_unique_exam_code", unique: true
  end

  create_table "op_exam_attendees", id: :serial, comment: "op.exam.attendees", force: :cascade do |t|
    t.integer "student_id", null: false, comment: "Student"
    t.string "status", null: false, comment: "Status"
    t.integer "marks", comment: "Marks"
    t.text "note", comment: "Note"
    t.integer "exam_id", null: false, comment: "Exam"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "room_id", comment: "Room"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["student_id", "exam_id"], name: "op_exam_attendees_unique_attendees", unique: true
  end

  create_table "op_exam_attendees_op_held_exam_rel", id: false, comment: "RELATION BETWEEN op_held_exam AND op_exam_attendees", force: :cascade do |t|
    t.integer "op_held_exam_id", null: false
    t.integer "op_exam_attendees_id", null: false
    t.index ["op_exam_attendees_id"], name: "op_exam_attendees_op_held_exam_rel_op_exam_attendees_id_idx"
    t.index ["op_held_exam_id", "op_exam_attendees_id"], name: "op_exam_attendees_op_held_exa_op_held_exam_id_op_exam_atten_key", unique: true
    t.index ["op_held_exam_id"], name: "op_exam_attendees_op_held_exam_rel_op_held_exam_id_idx"
  end

  create_table "op_exam_op_faculty_rel", id: false, comment: "RELATION BETWEEN op_exam AND op_faculty", force: :cascade do |t|
    t.integer "op_exam_id", null: false
    t.integer "op_faculty_id", null: false
    t.index ["op_exam_id", "op_faculty_id"], name: "op_exam_op_faculty_rel_op_exam_id_op_faculty_id_key", unique: true
    t.index ["op_exam_id"], name: "op_exam_op_faculty_rel_op_exam_id_idx"
    t.index ["op_faculty_id"], name: "op_exam_op_faculty_rel_op_faculty_id_idx"
  end

  create_table "op_exam_room", id: :serial, comment: "op.exam.room", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "classroom_id", null: false, comment: "Classroom"
    t.integer "capacity", null: false, comment: "Capacity"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_exam_room_op_room_distribution_rel", id: false, comment: "RELATION BETWEEN op_room_distribution AND op_exam_room", force: :cascade do |t|
    t.integer "op_room_distribution_id", null: false
    t.integer "op_exam_room_id", null: false
    t.index ["op_exam_room_id"], name: "op_exam_room_op_room_distribution_rel_op_exam_room_id_idx"
    t.index ["op_room_distribution_id", "op_exam_room_id"], name: "op_exam_room_op_room_distribu_op_room_distribution_id_op_ex_key", unique: true
    t.index ["op_room_distribution_id"], name: "op_exam_room_op_room_distribution_r_op_room_distribution_id_idx"
  end

  create_table "op_exam_session", id: :serial, comment: "Exam Session", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Exam Session"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.string "exam_code", null: false, comment: "Exam Session Code"
    t.date "start_date", null: false, comment: "Start Date"
    t.date "end_date", null: false, comment: "End Date"
    t.integer "exam_type", null: false, comment: "Exam Type"
    t.string "evaluation_type", null: false, comment: "Evolution type"
    t.integer "venue", comment: "Venue"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["exam_code"], name: "op_exam_session_unique_exam_session_code", unique: true
  end

  create_table "op_exam_type", id: :serial, comment: "op.exam.type", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "op_exam_type_unique_exam_type_code", unique: true
  end

  create_table "op_facility", id: :serial, comment: "op.facility", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "op_facility_unique_facility_code", unique: true
  end

  create_table "op_facility_line", id: :serial, comment: "op.facility.line", force: :cascade do |t|
    t.integer "facility_id", null: false, comment: "Facility"
    t.float "quantity", null: false, comment: "Quantity"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "classroom_id", comment: "Classroom"
  end

  create_table "op_faculty", id: :serial, comment: "op.faculty", force: :cascade do |t|
    t.integer "partner_id", null: false, comment: "Partner"
    t.string "middle_name", limit: 128, comment: "Middle Name"
    t.string "last_name", limit: 128, null: false, comment: "Last Name"
    t.date "birth_date", comment: "Birth Date"
    t.string "blood_group", comment: "Blood Group"
    t.string "gender", null: false, comment: "Gender"
    t.integer "nationality", comment: "Nationality"
    t.integer "emergency_contact", comment: "Emergency Contact"
    t.string "visa_info", limit: 64, comment: "Visa Info"
    t.string "id_number", limit: 64, comment: "ID Card Number"
    t.integer "emp_id", comment: "Employee"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "library_card_id", comment: "Library Card"
    t.integer "company_id", comment: "Company"
    t.string "full_name", comment: "Full name"
    t.string "status", comment: "Tình trạng giảng viên"
    t.integer "related_user", comment: "Related User"
    t.string "faculty_level", comment: "Level of falcuty"
    t.string "type_of_faculty", comment: "Type of faculty"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "ranking", comment: "Ranking"
  end

  create_table "op_faculty_op_subject_rel", id: false, comment: "RELATION BETWEEN op_faculty AND op_subject", force: :cascade do |t|
    t.integer "op_faculty_id", null: false
    t.integer "op_subject_id", null: false
    t.index ["op_faculty_id", "op_subject_id"], name: "op_faculty_op_subject_rel_op_faculty_id_op_subject_id_key", unique: true
    t.index ["op_faculty_id"], name: "op_faculty_op_subject_rel_op_faculty_id_idx"
    t.index ["op_subject_id"], name: "op_faculty_op_subject_rel_op_subject_id_idx"
  end

  create_table "op_faculty_wizard_merge_faculty_rel", id: false, comment: "RELATION BETWEEN wizard_merge_faculty AND op_faculty", force: :cascade do |t|
    t.integer "wizard_merge_faculty_id", null: false
    t.integer "op_faculty_id", null: false
    t.index ["op_faculty_id"], name: "op_faculty_wizard_merge_faculty_rel_op_faculty_id_idx"
    t.index ["wizard_merge_faculty_id", "op_faculty_id"], name: "op_faculty_wizard_merge_facul_wizard_merge_faculty_id_op_fa_key", unique: true
    t.index ["wizard_merge_faculty_id"], name: "op_faculty_wizard_merge_faculty_rel_wizard_merge_faculty_id_idx"
  end

  create_table "op_faculty_wizard_op_faculty_rel", id: false, comment: "RELATION BETWEEN wizard_op_faculty AND op_faculty", force: :cascade do |t|
    t.integer "wizard_op_faculty_id", null: false
    t.integer "op_faculty_id", null: false
    t.index ["op_faculty_id"], name: "op_faculty_wizard_op_faculty_rel_op_faculty_id_idx"
    t.index ["wizard_op_faculty_id", "op_faculty_id"], name: "op_faculty_wizard_op_faculty__wizard_op_faculty_id_op_facul_key", unique: true
    t.index ["wizard_op_faculty_id"], name: "op_faculty_wizard_op_faculty_rel_wizard_op_faculty_id_idx"
  end

  create_table "op_fees_terms", id: :serial, comment: "op.fees.terms", force: :cascade do |t|
    t.string "name", null: false, comment: "Fees Terms"
    t.boolean "active", comment: "Active"
    t.text "note", comment: "Description"
    t.integer "company_id", null: false, comment: "Company"
    t.integer "no_days", comment: "No of Days"
    t.string "day_type", comment: "Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_fees_terms_line", id: :serial, comment: "op.fees.terms.line", force: :cascade do |t|
    t.integer "due_days", comment: "Due Days"
    t.float "value", comment: "Value (%)"
    t.integer "fees_id", comment: "Fees"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_gamification_badge", id: :serial, comment: "Gamification badge", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "rule_auth", null: false, comment: "Allowance to Grant"
    t.boolean "rule_max", comment: "Monthly Limited Sending"
    t.integer "rule_max_number", comment: "Limitation Number"
    t.string "name", null: false, comment: "Badge"
    t.boolean "active", comment: "Active"
    t.text "description", comment: "Description"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_grade_configuration", id: :serial, comment: "op.grade.configuration", force: :cascade do |t|
    t.integer "min_per", null: false, comment: "Minimum Percentage"
    t.integer "max_per", null: false, comment: "Maximum Percentage"
    t.string "result", null: false, comment: "Result to Display"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_grade_configuration_op_result_template_rel", id: false, comment: "RELATION BETWEEN op_result_template AND op_grade_configuration", force: :cascade do |t|
    t.integer "op_result_template_id", null: false
    t.integer "op_grade_configuration_id", null: false
    t.index ["op_grade_configuration_id"], name: "op_grade_configuration_op_result__op_grade_configuration_id_idx"
    t.index ["op_result_template_id", "op_grade_configuration_id"], name: "op_grade_configuration_op_res_op_result_template_id_op_grad_key", unique: true
    t.index ["op_result_template_id"], name: "op_grade_configuration_op_result_temp_op_result_template_id_idx"
  end

  create_table "op_held_exam", id: :serial, comment: "op.held.exam", force: :cascade do |t|
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "exam_id", comment: "Exam"
    t.integer "subject_id", comment: "Subject"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_lession", id: :serial, comment: "op.lession", force: :cascade do |t|
    t.string "code", comment: "Code"
    t.integer "subject_id", null: false, comment: "Subject"
    t.integer "lession_number", comment: "lession number"
    t.text "name", null: false, comment: "Name"
    t.text "note", null: false, comment: "Target"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.text "learning_devices", comment: "Learning Devices"
  end

  create_table "op_library_card", id: :serial, comment: "Library Card", force: :cascade do |t|
    t.integer "partner_id", null: false, comment: "Student/Faculty"
    t.string "number", limit: 256, comment: "Number"
    t.integer "library_card_type_id", null: false, comment: "Card Type"
    t.date "issue_date", null: false, comment: "Issue Date"
    t.string "type", null: false, comment: "Type"
    t.integer "student_id", comment: "Student"
    t.integer "faculty_id", comment: "Faculty"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["number"], name: "op_library_card_unique_library_card_number", unique: true
  end

  create_table "op_library_card_type", id: :serial, comment: "Library Card Type", force: :cascade do |t|
    t.string "name", limit: 256, null: false, comment: "Name"
    t.integer "allow_media", null: false, comment: "No of medias Allowed"
    t.integer "duration", null: false, comment: "Duration"
    t.float "penalty_amt_per_day", null: false, comment: "Penalty Amount per Day"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_marksheet_line", id: :serial, comment: "op.marksheet.line", force: :cascade do |t|
    t.integer "marksheet_reg_id", comment: "Marksheet Register"
    t.string "evaluation_type", comment: "Evolution type"
    t.integer "student_id", null: false, comment: "Student"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_marksheet_register", id: :serial, comment: "op.marksheet.register", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "exam_session_id", null: false, comment: "Exam Session"
    t.date "generated_date", null: false, comment: "Generated Date"
    t.integer "generated_by", null: false, comment: "Generated By"
    t.string "status", null: false, comment: "Status"
    t.string "name", null: false, comment: "Marksheet Register"
    t.integer "result_template_id", null: false, comment: "Result Template"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_media", id: :serial, comment: "op.media", force: :cascade do |t|
    t.string "name", limit: 128, null: false, comment: "Title"
    t.string "isbn", limit: 64, comment: "ISBN Code"
    t.string "edition", comment: "Edition"
    t.text "description", comment: "Description"
    t.string "internal_code", limit: 64, comment: "Internal Code"
    t.integer "media_type_id", comment: "Media Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "company_id", comment: "Company"
    t.index ["internal_code"], name: "op_media_unique_name_internal_code", unique: true
    t.index ["isbn"], name: "op_media_unique_name_isbn", unique: true
  end

  create_table "op_media_movement", id: :serial, comment: "Media Movement", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "media_id", null: false, comment: "Media"
    t.integer "media_unit_id", null: false, comment: "Media Unit"
    t.string "type", null: false, comment: "Student/Faculty"
    t.integer "student_id", comment: "Student"
    t.integer "faculty_id", comment: "Faculty"
    t.integer "library_card_id", null: false, comment: "Library Card"
    t.date "issued_date", null: false, comment: "Issued Date"
    t.date "return_date", null: false, comment: "Due Date"
    t.date "actual_return_date", comment: "Actual Return Date"
    t.float "penalty", comment: "Penalty"
    t.integer "partner_id", comment: "Person"
    t.string "reserver_name", limit: 256, comment: "Person Name"
    t.string "state", comment: "Status"
    t.integer "media_type_id", comment: "Media Type"
    t.integer "invoice_id", comment: "Invoice"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "employee_id", comment: "Employee"
    t.integer "manager_id", comment: "Manager"
  end

  create_table "op_media_op_publisher_rel", id: false, comment: "RELATION BETWEEN op_media AND op_publisher", force: :cascade do |t|
    t.integer "op_media_id", null: false
    t.integer "op_publisher_id", null: false
    t.index ["op_media_id", "op_publisher_id"], name: "op_media_op_publisher_rel_op_media_id_op_publisher_id_key", unique: true
    t.index ["op_media_id"], name: "op_media_op_publisher_rel_op_media_id_idx"
    t.index ["op_publisher_id"], name: "op_media_op_publisher_rel_op_publisher_id_idx"
  end

  create_table "op_media_op_subject_rel", id: false, comment: "RELATION BETWEEN op_media AND op_subject", force: :cascade do |t|
    t.integer "op_media_id", null: false
    t.integer "op_subject_id", null: false
    t.index ["op_media_id", "op_subject_id"], name: "op_media_op_subject_rel_op_media_id_op_subject_id_key", unique: true
    t.index ["op_media_id"], name: "op_media_op_subject_rel_op_media_id_idx"
    t.index ["op_subject_id"], name: "op_media_op_subject_rel_op_subject_id_idx"
  end

  create_table "op_media_op_tag_rel", id: false, comment: "RELATION BETWEEN op_media AND op_tag", force: :cascade do |t|
    t.integer "op_media_id", null: false
    t.integer "op_tag_id", null: false
    t.index ["op_media_id", "op_tag_id"], name: "op_media_op_tag_rel_op_media_id_op_tag_id_key", unique: true
    t.index ["op_media_id"], name: "op_media_op_tag_rel_op_media_id_idx"
    t.index ["op_tag_id"], name: "op_media_op_tag_rel_op_tag_id_idx"
  end

  create_table "op_media_purchase", id: :serial, comment: "Media Purchase Request", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", limit: 128, null: false, comment: "Title"
    t.string "author", limit: 256, null: false, comment: "Author(s)"
    t.string "edition", comment: "Edition"
    t.string "publisher", limit: 256, comment: "Publisher(s)"
    t.integer "course_ids", null: false, comment: "Course"
    t.integer "subject_ids", null: false, comment: "Subject"
    t.integer "requested_id", comment: "Requested By"
    t.string "state", comment: "State"
    t.integer "media_type_id", comment: "Media Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_media_queue", id: :serial, comment: "Media Queue Request", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Sequence No"
    t.integer "partner_id", comment: "Student/Faculty"
    t.integer "media_id", null: false, comment: "Media"
    t.date "date_from", null: false, comment: "From Date"
    t.date "date_to", null: false, comment: "To Date"
    t.integer "user_id", comment: "User"
    t.string "state", comment: "Status"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_media_type", id: :serial, comment: "op.media.type", force: :cascade do |t|
    t.string "name", limit: 64, null: false, comment: "Name"
    t.string "code", limit: 64, null: false, comment: "Code"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "op_media_type_unique_media_type_code", unique: true
  end

  create_table "op_media_unit", id: :serial, comment: "Media Unit", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", null: false, comment: "Name"
    t.integer "media_id", null: false, comment: "Media"
    t.string "barcode", limit: 20, comment: "Barcode"
    t.string "state", comment: "State"
    t.integer "media_type_id", comment: "Media Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["barcode"], name: "op_media_unit_unique_name_barcode", unique: true
  end

  create_table "op_parent", id: :serial, comment: "op.parent", force: :cascade do |t|
    t.integer "name", null: false, comment: "Name"
    t.integer "user_id", comment: "User"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "phone", comment: "Phone"
    t.string "mobile", comment: "Mobile"
    t.string "email", comment: "Email"
    t.boolean "active", comment: "Active"
  end

  create_table "op_parent_op_student_rel", id: false, comment: "RELATION BETWEEN op_parent AND op_student", force: :cascade do |t|
    t.integer "op_parent_id", null: false
    t.integer "op_student_id", null: false
    t.index ["op_parent_id", "op_student_id"], name: "op_parent_op_student_rel_op_parent_id_op_student_id_key", unique: true
    t.index ["op_parent_id"], name: "op_parent_op_student_rel_op_parent_id_idx"
    t.index ["op_student_id"], name: "op_parent_op_student_rel_op_student_id_idx"
  end

  create_table "op_publisher", id: :serial, comment: "op.publisher", force: :cascade do |t|
    t.string "name", limit: 20, null: false, comment: "Name"
    t.integer "address_id", comment: "Address"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_result_line", id: :serial, comment: "op.result.line", force: :cascade do |t|
    t.integer "marksheet_line_id", comment: "Marksheet Line"
    t.integer "exam_id", null: false, comment: "Exam"
    t.string "evaluation_type", comment: "Evolution type"
    t.integer "marks", null: false, comment: "Marks"
    t.integer "student_id", null: false, comment: "Student"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_result_template", id: :serial, comment: "Result Template", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "exam_session_id", null: false, comment: "Exam Session"
    t.string "evaluation_type", comment: "Evolution type"
    t.string "name", null: false, comment: "Name"
    t.date "result_date", null: false, comment: "Result Date"
    t.string "state", comment: "State"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_room_distribution", id: :serial, comment: "op.room.distribution", force: :cascade do |t|
    t.integer "exam_id", comment: "Exam"
    t.integer "subject_id", comment: "Subject"
    t.string "name", comment: "Exam"
    t.datetime "start_time", comment: "Start Time"
    t.datetime "end_time", comment: "End Time"
    t.integer "exam_session", comment: "Exam Session"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_room_distribution_op_student_rel", id: false, comment: "RELATION BETWEEN op_room_distribution AND op_student", force: :cascade do |t|
    t.integer "op_room_distribution_id", null: false
    t.integer "op_student_id", null: false
    t.index ["op_room_distribution_id", "op_student_id"], name: "op_room_distribution_op_stude_op_room_distribution_id_op_st_key", unique: true
    t.index ["op_room_distribution_id"], name: "op_room_distribution_op_student_rel_op_room_distribution_id_idx"
    t.index ["op_student_id"], name: "op_room_distribution_op_student_rel_op_student_id_idx"
  end

  create_table "op_session", id: :serial, comment: "Sessions", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Name"
    t.integer "timing_id", null: false, comment: "Timing"
    t.datetime "start_datetime", null: false, comment: "Start Time"
    t.datetime "end_datetime", null: false, comment: "End Time"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "faculty_id", null: false, comment: "Faculty"
    t.integer "batch_id", comment: "Batch"
    t.integer "subject_id", null: false, comment: "Subject"
    t.integer "classroom_id", comment: "Classroom"
    t.integer "color", comment: "Color Index"
    t.string "type", comment: "Day"
    t.string "state", comment: "Status"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "company_id", comment: "Company"
    t.integer "user_id", comment: "User"
    t.boolean "is_offset", comment: "Offset"
    t.integer "level", comment: "Level"
    t.boolean "sendEmail", comment: "Đã gửi thư mời giảng"
    t.boolean "send_email", comment: "Đã gửi thư mời giảng"
    t.string "count", comment: "Status"
    t.string "attendance_state", comment: "Attendance State"
    t.datetime "check_in_time", comment: "Check-in"
    t.string "check_in_state", comment: "Check-in Status"
    t.boolean "is_observed", comment: "Observed?"
    t.integer "observe_faculty", comment: "Class Observer"
    t.text "observe_report", comment: "Observation Report"
    t.string "observe_link", comment: "Report Link"
    t.text "teacher", comment: "Evaluation for teachers"
    t.boolean "teacher_tick", comment: "Livestream"
    t.boolean "check_teacher", comment: "Check Evaluation"
    t.integer "assessor", comment: "Assessor"
    t.datetime "evaluation_date", comment: "Evaluation Date"
    t.boolean "attend_match", comment: "Attendance info is matching?"
    t.float "time_count", comment: "Time count"
    t.integer "batch_count", comment: "Batch Count"
    t.integer "course_categ", comment: "Course Category"
    t.integer "salary", comment: "Salary"
    t.string "select_language", comment: "Select Language"
    t.string "select_place", comment: "Select Place"
    t.integer "student_course_id", comment: "Admission Details"
    t.string "faculty_level", comment: "Level of falcuty"
    t.string "type_of_faculty", comment: "Type of faculty"
    t.string "language", comment: "Language"
    t.string "select_place_related", comment: "Select Place"
    t.string "reason_cancel_class", comment: "Select Reason Cancel"
    t.string "reason_cancel", comment: "Lí do"
    t.string "select_type", comment: "Select Type"
    t.boolean "last_session", comment: "Cuối khóa"
    t.integer "logistic_line_count", comment: "Logistic Count"
    t.string "logistic_note", comment: "Note"
    t.text "logistic_comment", comment: "Comment"
    t.float "salary_before", comment: "Lương trước khi phạt"
    t.float "salary_per_hour", comment: "Lương theo giờ"
    t.boolean "active", comment: "Active"
    t.integer "lession_id", comment: "Lesson"
  end

  create_table "op_session_change_faculty", id: :serial, comment: "op.session.change.faculty", force: :cascade do |t|
    t.integer "faculty_id", null: false, comment: "Faculty"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.integer "subject_id", null: false, comment: "Subject"
    t.datetime "start_datetime", comment: "Start Time"
    t.datetime "end_datetime", comment: "End Time"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_session_offset_student", id: false, comment: "RELATION BETWEEN op_session AND op_student", force: :cascade do |t|
    t.integer "session_id", null: false
    t.integer "student_id", null: false
    t.index ["session_id", "student_id"], name: "op_session_offset_student_session_id_student_id_key", unique: true
    t.index ["session_id"], name: "op_session_offset_student_session_id_idx"
    t.index ["student_id"], name: "op_session_offset_student_student_id_idx"
  end

  create_table "op_session_res_users_rel", id: false, comment: "RELATION BETWEEN op_session AND res_users", force: :cascade do |t|
    t.integer "op_session_id", null: false
    t.integer "res_users_id", null: false
    t.index ["op_session_id", "res_users_id"], name: "op_session_res_users_rel_op_session_id_res_users_id_key", unique: true
    t.index ["op_session_id"], name: "op_session_res_users_rel_op_session_id_idx"
    t.index ["res_users_id"], name: "op_session_res_users_rel_res_users_id_idx"
  end

  create_table "op_session_student", id: :serial, comment: "op.session.student", force: :cascade do |t|
    t.integer "session_id", comment: "Session"
    t.integer "student_course_id", comment: "Admission Details"
    t.boolean "is_presend", comment: "Presend"
    t.text "note", comment: "Note"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "is_present", comment: "Presend"
    t.boolean "present", comment: "Present"
    t.integer "batch_id", comment: "Batch"
    t.datetime "start_datetime", comment: "Start Time"
    t.datetime "end_datetime", comment: "End Time"
    t.integer "company_id", comment: "Company"
    t.integer "classroom_id", comment: "Classroom"
  end

  create_table "op_student", id: :serial, comment: "op.student", force: :cascade do |t|
    t.string "middle_name", limit: 128, comment: "Middle Name"
    t.string "last_name", limit: 128, comment: "Last Name"
    t.date "birth_date", comment: "Birth Date"
    t.string "blood_group", comment: "Blood Group"
    t.string "gender", comment: "Gender"
    t.integer "nationality", comment: "Nationality"
    t.integer "emergency_contact", comment: "Emergency Contact"
    t.string "visa_info", limit: 64, comment: "Visa Info"
    t.string "id_number", limit: 64, comment: "ID Card Number"
    t.boolean "already_partner", comment: "Already Partner"
    t.integer "partner_id", null: false, comment: "Partner"
    t.string "gr_no", limit: 20, comment: "GR Number"
    t.integer "category_id", comment: "Category"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "library_card_id", comment: "Library Card"
    t.integer "company_id", comment: "Company"
    t.string "full_name", comment: "Full name"
    t.string "parent_mail", comment: "Parent email"
    t.integer "parent_id", comment: "Parent email"
    t.string "state", comment: "State"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "code", comment: "Code"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.boolean "active", comment: "Active"
    t.integer "age", comment: "Age"
    t.datetime "real_start_date", comment: "Start Date"
    t.datetime "real_end_date", comment: "End Date"
    t.float "duration", comment: "Durarion (Days)"
    t.string "birth_dd", comment: "Birth Day"
    t.string "birth_mm", comment: "Birth Month"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.string "parent_email", comment: "Parent email"
  end

  create_table "op_student_attendance_report", id: :serial, comment: "student report", force: :cascade do |t|
    t.integer "student_id", comment: "Student"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "session_total", comment: "Total Session"
    t.integer "session_done", comment: "Session Done"
    t.integer "session_present", comment: "Present"
    t.float "session_present_percent", comment: "% Present"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_student_course", id: :serial, comment: "Student Course Details", force: :cascade do |t|
    t.integer "student_id", comment: "Student"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.string "roll_number", comment: "Roll Number"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "company_id", comment: "Company"
    t.string "state", comment: "State"
    t.boolean "active", comment: "Active"
    t.date "reserve_from", comment: "Reserve From"
    t.date "reserve_to", comment: "Reserve To"
    t.text "reserve_note", comment: "Reservation Note"
    t.boolean "manual_state", comment: "Manual State"
    t.datetime "start_date", comment: "Start Date"
    t.datetime "end_date", comment: "End Date"
    t.integer "categ_id", comment: "Course Category"
    t.string "gender", comment: "Gender"
    t.date "birth_date", comment: "Birth Date"
    t.text "lesson_link", comment: "Link bài tập"
    t.string "parent_email", comment: "Parent email"
    t.index ["roll_number", "course_id", "batch_id", "student_id"], name: "op_student_course_unique_name_roll_number_id", unique: true
    t.index ["roll_number", "course_id", "batch_id"], name: "op_student_course_unique_name_roll_number_course_id", unique: true
    t.index ["student_id", "course_id", "batch_id"], name: "op_student_course_unique_name_roll_number_student_id", unique: true
  end

  create_table "op_student_course_op_subject_rel", id: false, comment: "RELATION BETWEEN op_student_course AND op_subject", force: :cascade do |t|
    t.integer "op_student_course_id", null: false
    t.integer "op_subject_id", null: false
    t.index ["op_student_course_id", "op_subject_id"], name: "op_student_course_op_subject__op_student_course_id_op_subje_key", unique: true
    t.index ["op_student_course_id"], name: "op_student_course_op_subject_rel_op_student_course_id_idx"
    t.index ["op_subject_id"], name: "op_student_course_op_subject_rel_op_subject_id_idx"
  end

  create_table "op_student_fees_details", id: :serial, comment: "Student Fees Details", force: :cascade do |t|
    t.integer "fees_line_id", comment: "Fees Line"
    t.integer "invoice_id", comment: "Invoice"
    t.float "amount", comment: "Fees Amount"
    t.date "date", comment: "Submit Date"
    t.integer "product_id", comment: "Product"
    t.integer "student_id", comment: "Student"
    t.string "state", comment: "Status"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_student_student_migrate_rel", id: false, comment: "RELATION BETWEEN student_migrate AND op_student", force: :cascade do |t|
    t.integer "student_migrate_id", null: false
    t.integer "op_student_id", null: false
    t.index ["op_student_id"], name: "op_student_student_migrate_rel_op_student_id_idx"
    t.index ["student_migrate_id", "op_student_id"], name: "op_student_student_migrate_re_student_migrate_id_op_student_key", unique: true
    t.index ["student_migrate_id"], name: "op_student_student_migrate_rel_student_migrate_id_idx"
  end

  create_table "op_student_subject", id: false, force: :cascade do |t|
    t.integer "student_course_id"
    t.integer "subject_id"
  end

  create_table "op_student_wizard_op_student_rel", id: false, comment: "RELATION BETWEEN wizard_op_student AND op_student", force: :cascade do |t|
    t.integer "wizard_op_student_id", null: false
    t.integer "op_student_id", null: false
    t.index ["op_student_id"], name: "op_student_wizard_op_student_rel_op_student_id_idx"
    t.index ["wizard_op_student_id", "op_student_id"], name: "op_student_wizard_op_student__wizard_op_student_id_op_stude_key", unique: true
    t.index ["wizard_op_student_id"], name: "op_student_wizard_op_student_rel_wizard_op_student_id_idx"
  end

  create_table "op_subject", id: :serial, comment: "op.subject", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Code"
    t.float "grade_weightage", comment: "Grade Weightage"
    t.string "type", null: false, comment: "Type"
    t.string "subject_type", null: false, comment: "Subject Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "company_id", comment: "Company"
    t.integer "course_id", comment: "Course"
    t.integer "total_session", comment: "Total Session"
    t.integer "level", comment: "Level"
    t.boolean "active", comment: "Active"
    t.index ["code"], name: "op_subject_unique_subject_code", unique: true
  end

  create_table "op_subject_op_subject_registration_rel", id: false, comment: "RELATION BETWEEN op_subject_registration AND op_subject", force: :cascade do |t|
    t.integer "op_subject_registration_id", null: false
    t.integer "op_subject_id", null: false
    t.index ["op_subject_id"], name: "op_subject_op_subject_registration_rel_op_subject_id_idx"
    t.index ["op_subject_registration_id", "op_subject_id"], name: "op_subject_op_subject_registr_op_subject_registration_id_op_key", unique: true
    t.index ["op_subject_registration_id"], name: "op_subject_op_subject_registrati_op_subject_registration_id_idx"
  end

  create_table "op_subject_registration", id: :serial, comment: "op.subject.registration", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "name", comment: "Name"
    t.integer "student_id", null: false, comment: "Student"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.string "state", comment: "state"
    t.float "max_unit_load", comment: "Maximum Unit Load"
    t.float "min_unit_load", comment: "Minimum Unit Load"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_tag", id: :serial, comment: "op.tag", force: :cascade do |t|
    t.string "name", limit: 64, null: false, comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "op_timing", id: :serial, comment: "Period", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "hour", null: false, comment: "Hours"
    t.string "minute", null: false, comment: "Minute"
    t.float "duration", comment: "Duration"
    t.string "am_pm", null: false, comment: "AM/PM"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "active", comment: "Active"
  end

  create_table "payment_acquirer", id: :serial, comment: "Payment Acquirer", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.text "description", comment: "Description"
    t.integer "sequence", comment: "Sequence"
    t.string "provider", null: false, comment: "Provider"
    t.integer "company_id", null: false, comment: "Company"
    t.integer "view_template_id", null: false, comment: "Form Button Template"
    t.integer "registration_view_template_id", comment: "S2S Form Template"
    t.string "environment", null: false, comment: "Environment"
    t.boolean "website_published", comment: "Visible in Portal / Website"
    t.boolean "capture_manually", comment: "Capture Amount Manually"
    t.integer "journal_id", comment: "Payment Journal"
    t.boolean "specific_countries", comment: "Specific Countries"
    t.text "pre_msg", comment: "Help Message"
    t.text "post_msg", comment: "Thanks Message"
    t.text "pending_msg", comment: "Pending Message"
    t.text "done_msg", comment: "Done Message"
    t.text "cancel_msg", comment: "Cancel Message"
    t.text "error_msg", comment: "Error Message"
    t.string "save_token", comment: "Save Cards"
    t.boolean "fees_active", comment: "Add Extra Fees"
    t.float "fees_dom_fixed", comment: "Fixed domestic fees"
    t.float "fees_dom_var", comment: "Variable domestic fees (in percents)"
    t.float "fees_int_fixed", comment: "Fixed international fees"
    t.float "fees_int_var", comment: "Variable international fees (in percents)"
    t.integer "module_id", comment: "Corresponding Module"
    t.string "payment_flow", null: false, comment: "Payment Flow"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "payment_acquirer_payment_icon_rel", id: false, comment: "RELATION BETWEEN payment_acquirer AND payment_icon", force: :cascade do |t|
    t.integer "payment_acquirer_id", null: false
    t.integer "payment_icon_id", null: false
    t.index ["payment_acquirer_id", "payment_icon_id"], name: "payment_acquirer_payment_icon_payment_acquirer_id_payment_i_key", unique: true
    t.index ["payment_acquirer_id"], name: "payment_acquirer_payment_icon_rel_payment_acquirer_id_idx"
    t.index ["payment_icon_id"], name: "payment_acquirer_payment_icon_rel_payment_icon_id_idx"
  end

  create_table "payment_country_rel", id: false, comment: "RELATION BETWEEN payment_acquirer AND res_country", force: :cascade do |t|
    t.integer "payment_id", null: false
    t.integer "country_id", null: false
    t.index ["country_id"], name: "payment_country_rel_country_id_idx"
    t.index ["payment_id", "country_id"], name: "payment_country_rel_payment_id_country_id_key", unique: true
    t.index ["payment_id"], name: "payment_country_rel_payment_id_idx"
  end

  create_table "payment_icon", id: :serial, comment: "Payment Icon", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "payment_token", id: :serial, comment: "payment.token", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "partner_id", null: false, comment: "Partner"
    t.integer "acquirer_id", null: false, comment: "Acquirer Account"
    t.string "acquirer_ref", null: false, comment: "Acquirer Ref."
    t.boolean "active", comment: "Active"
    t.boolean "verified", comment: "Verified"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "payment_transaction", id: :serial, comment: "Payment Transaction", force: :cascade do |t|
    t.datetime "create_date", comment: "Creation Date"
    t.datetime "date_validate", comment: "Validation Date"
    t.integer "acquirer_id", null: false, comment: "Acquirer"
    t.string "type", null: false, comment: "Type"
    t.string "state", null: false, comment: "Status"
    t.text "state_message", comment: "Message"
    t.decimal "amount", null: false, comment: "Amount"
    t.decimal "fees", comment: "Fees"
    t.integer "currency_id", null: false, comment: "Currency"
    t.string "reference", null: false, comment: "Reference"
    t.string "acquirer_reference", comment: "Acquirer Reference"
    t.integer "partner_id", comment: "Customer"
    t.string "partner_name", comment: "Partner Name"
    t.string "partner_lang", comment: "Language"
    t.string "partner_email", comment: "Email"
    t.string "partner_zip", comment: "Zip"
    t.string "partner_address", comment: "Address"
    t.string "partner_city", comment: "City"
    t.integer "partner_country_id", null: false, comment: "Country"
    t.string "partner_phone", comment: "Phone"
    t.string "html_3ds", comment: "3D Secure HTML"
    t.integer "callback_model_id", comment: "Callback Document Model"
    t.integer "callback_res_id", comment: "Callback Document ID"
    t.string "callback_method", comment: "Callback Method"
    t.string "callback_hash", comment: "Callback Hash"
    t.integer "payment_token_id", comment: "Payment Token"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "sale_order_id", comment: "Sales Order"
    t.integer "account_invoice_id", comment: "Invoice"
  end

  create_table "payslip_lines_contribution_register", id: :serial, comment: "PaySlip Lines by Contribution Registers", force: :cascade do |t|
    t.date "date_from", null: false, comment: "Date From"
    t.date "date_to", null: false, comment: "Date To"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "portal_wizard", id: :serial, comment: "Portal Access Management", force: :cascade do |t|
    t.integer "portal_id", null: false, comment: "Portal"
    t.text "welcome_message", comment: "Invitation Message"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "portal_wizard_user", id: :serial, comment: "Portal User Config", force: :cascade do |t|
    t.integer "wizard_id", null: false, comment: "Wizard"
    t.integer "partner_id", null: false, comment: "Contact"
    t.string "email", comment: "Email"
    t.boolean "in_portal", comment: "In Portal"
    t.integer "user_id", comment: "Login User"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "pos_category", id: :serial, comment: "PoS Category", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "parent_id", comment: "Parent Category"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["parent_id"], name: "pos_category_parent_id_index"
  end

  create_table "pos_config", id: :serial, comment: "pos.config", force: :cascade do |t|
    t.string "name", null: false, comment: "Point of Sale Name"
    t.integer "picking_type_id", comment: "Operation Type"
    t.integer "stock_location_id", null: false, comment: "Stock Location"
    t.integer "journal_id", comment: "Sales Journal"
    t.integer "invoice_journal_id", comment: "Invoice Journal"
    t.boolean "iface_cashdrawer", comment: "Cashdrawer"
    t.boolean "iface_payment_terminal", comment: "Payment Terminal"
    t.boolean "iface_electronic_scale", comment: "Electronic Scale"
    t.boolean "iface_vkeyboard", comment: "Virtual KeyBoard"
    t.boolean "iface_customer_facing_display", comment: "Customer Facing Display"
    t.boolean "iface_print_via_proxy", comment: "Print via Proxy"
    t.boolean "iface_scan_via_proxy", comment: "Scan via Proxy"
    t.boolean "iface_invoicing", comment: "Invoicing"
    t.boolean "iface_big_scrollbars", comment: "Large Scrollbars"
    t.boolean "iface_print_auto", comment: "Automatic Receipt Printing"
    t.boolean "iface_print_skip_screen", comment: "Skip Preview Screen"
    t.boolean "iface_precompute_cash", comment: "Prefill Cash Payment"
    t.string "iface_tax_included", null: false, comment: "Tax Display"
    t.integer "iface_start_categ_id", comment: "Initial Category"
    t.boolean "iface_display_categ_images", comment: "Display Category Pictures"
    t.boolean "restrict_price_control", comment: "Restrict Price Modifications to Managers"
    t.boolean "cash_control", comment: "Cash Control"
    t.text "receipt_header", comment: "Receipt Header"
    t.text "receipt_footer", comment: "Receipt Footer"
    t.string "proxy_ip", limit: 45, comment: "IP Address"
    t.boolean "active", comment: "Active"
    t.string "uuid", comment: "Uuid"
    t.integer "sequence_id", comment: "Order IDs Sequence"
    t.integer "sequence_line_id", comment: "Order Line IDs Sequence"
    t.boolean "group_by", comment: "Group Journal Items"
    t.integer "pricelist_id", null: false, comment: "Default Pricelist"
    t.integer "company_id", null: false, comment: "Company"
    t.integer "barcode_nomenclature_id", comment: "Barcode Nomenclature"
    t.integer "group_pos_manager_id", comment: "Point of Sale Manager Group"
    t.integer "group_pos_user_id", comment: "Point of Sale User Group"
    t.boolean "iface_tipproduct", comment: "Product tips"
    t.integer "tip_product_id", comment: "Tip Product"
    t.integer "default_fiscal_position_id", comment: "Default Fiscal Position"
    t.text "customer_facing_display_html", comment: "Customer facing display content"
    t.boolean "use_pricelist", comment: "Use a pricelist."
    t.boolean "group_sale_pricelist", comment: "Use pricelists to adapt your price per customers"
    t.boolean "group_pricelist_item", comment: "Show pricelists to customers"
    t.boolean "tax_regime", comment: "Tax Regime"
    t.boolean "tax_regime_selection", comment: "Tax Regime Selection value"
    t.boolean "barcode_scanner", comment: "Barcode Scanner"
    t.boolean "start_category", comment: "Set Start Category"
    t.boolean "module_pos_restaurant", comment: "Is a Bar/Restaurant"
    t.boolean "module_pos_discount", comment: "Global Discounts"
    t.boolean "module_pos_loyalty", comment: "Loyalty Program"
    t.boolean "module_pos_mercury", comment: "Integrated Card Payments"
    t.boolean "module_pos_reprint", comment: "Reprint Receipt"
    t.boolean "is_posbox", comment: "PosBox"
    t.boolean "is_header_or_footer", comment: "Header & Footer"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "pos_config_name_index"
  end

  create_table "pos_config_journal_rel", id: false, comment: "RELATION BETWEEN pos_config AND account_journal", force: :cascade do |t|
    t.integer "pos_config_id", null: false
    t.integer "journal_id", null: false
    t.index ["journal_id"], name: "pos_config_journal_rel_journal_id_idx"
    t.index ["pos_config_id", "journal_id"], name: "pos_config_journal_rel_pos_config_id_journal_id_key", unique: true
    t.index ["pos_config_id"], name: "pos_config_journal_rel_pos_config_id_idx"
  end

  create_table "pos_config_product_pricelist_rel", id: false, comment: "RELATION BETWEEN pos_config AND product_pricelist", force: :cascade do |t|
    t.integer "pos_config_id", null: false
    t.integer "product_pricelist_id", null: false
    t.index ["pos_config_id", "product_pricelist_id"], name: "pos_config_product_pricelist__pos_config_id_product_priceli_key", unique: true
    t.index ["pos_config_id"], name: "pos_config_product_pricelist_rel_pos_config_id_idx"
    t.index ["product_pricelist_id"], name: "pos_config_product_pricelist_rel_product_pricelist_id_idx"
  end

  create_table "pos_detail_configs", id: false, comment: "RELATION BETWEEN pos_details_wizard AND pos_config", force: :cascade do |t|
    t.integer "pos_details_wizard_id", null: false
    t.integer "pos_config_id", null: false
    t.index ["pos_config_id"], name: "pos_detail_configs_pos_config_id_idx"
    t.index ["pos_details_wizard_id", "pos_config_id"], name: "pos_detail_configs_pos_details_wizard_id_pos_config_id_key", unique: true
    t.index ["pos_details_wizard_id"], name: "pos_detail_configs_pos_details_wizard_id_idx"
  end

  create_table "pos_details_wizard", id: :serial, comment: "Open Sales Details Report", force: :cascade do |t|
    t.datetime "start_date", null: false, comment: "Start Date"
    t.datetime "end_date", null: false, comment: "End Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "pos_discount", id: :serial, comment: "Add a Global Discount", force: :cascade do |t|
    t.decimal "discount", null: false, comment: "Discount (%)"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "pos_make_payment", id: :serial, comment: "Point of Sale Payment", force: :cascade do |t|
    t.integer "session_id", null: false, comment: "Session"
    t.integer "journal_id", null: false, comment: "Payment Mode"
    t.decimal "amount", null: false, comment: "Amount"
    t.string "payment_name", comment: "Payment Reference"
    t.date "payment_date", null: false, comment: "Payment Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "pos_open_statement", id: :serial, comment: "Open Statements", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "pos_order", id: :serial, comment: "Point of Sale Orders", force: :cascade do |t|
    t.string "name", null: false, comment: "Order Ref"
    t.integer "company_id", null: false, comment: "Company"
    t.datetime "date_order", comment: "Order Date"
    t.integer "user_id", comment: "Salesman"
    t.integer "pricelist_id", null: false, comment: "Pricelist"
    t.integer "partner_id", comment: "Customer"
    t.integer "sequence_number", comment: "Sequence Number"
    t.integer "session_id", null: false, comment: "Session"
    t.string "state", comment: "Status"
    t.integer "invoice_id", comment: "Invoice"
    t.integer "account_move", comment: "Journal Entry"
    t.integer "picking_id", comment: "Picking"
    t.integer "location_id", comment: "Location"
    t.text "note", comment: "Internal Notes"
    t.integer "nb_print", comment: "Number of Print"
    t.string "pos_reference", comment: "Receipt Ref"
    t.integer "sale_journal", comment: "Sales Journal"
    t.integer "fiscal_position_id", comment: "Fiscal Position"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["date_order"], name: "pos_order_date_order_index"
    t.index ["partner_id"], name: "pos_order_partner_id_index"
    t.index ["session_id"], name: "pos_order_session_id_index"
  end

  create_table "pos_order_line", id: :serial, comment: "Lines of Point of Sale Orders", force: :cascade do |t|
    t.integer "company_id", null: false, comment: "Company"
    t.string "name", null: false, comment: "Line No"
    t.string "notice", comment: "Discount Notice"
    t.integer "product_id", null: false, comment: "Product"
    t.decimal "price_unit", comment: "Unit Price"
    t.decimal "qty", comment: "Quantity"
    t.decimal "discount", comment: "Discount (%)"
    t.integer "order_id", comment: "Order Ref"
    t.datetime "create_date", comment: "Creation Date"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "pos_pack_operation_lot", id: :serial, comment: "Specify product lot/serial number in pos order line", force: :cascade do |t|
    t.integer "pos_order_line_id", comment: "Pos Order Line"
    t.string "lot_name", comment: "Lot Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "pos_session", id: :serial, comment: "pos.session", force: :cascade do |t|
    t.integer "config_id", null: false, comment: "Point of Sale"
    t.string "name", null: false, comment: "Session ID"
    t.integer "user_id", null: false, comment: "Responsible"
    t.datetime "start_at", comment: "Opening Date"
    t.datetime "stop_at", comment: "Closing Date"
    t.string "state", null: false, comment: "Status"
    t.integer "sequence_number", comment: "Order Sequence Number"
    t.integer "login_number", comment: "Login Sequence Number"
    t.integer "cash_journal_id", comment: "Cash Journal"
    t.integer "cash_register_id", comment: "Cash Register"
    t.boolean "rescue", comment: "Recovery Session"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["config_id"], name: "pos_session_config_id_index"
    t.index ["name"], name: "pos_session_uniq_name", unique: true
    t.index ["state"], name: "pos_session_state_index"
    t.index ["user_id"], name: "pos_session_user_id_index"
  end

  create_table "product_attribute", id: :serial, comment: "Product Attribute", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "sequence", comment: "Sequence"
    t.boolean "create_variant", comment: "Create Variant"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "product_attribute_line", id: :serial, comment: "product.attribute.line", force: :cascade do |t|
    t.integer "product_tmpl_id", null: false, comment: "Product Template"
    t.integer "attribute_id", null: false, comment: "Attribute"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "product_attribute_line_product_attribute_value_rel", id: false, comment: "RELATION BETWEEN product_attribute_line AND product_attribute_value", force: :cascade do |t|
    t.integer "product_attribute_line_id", null: false
    t.integer "product_attribute_value_id", null: false
    t.index ["product_attribute_line_id", "product_attribute_value_id"], name: "product_attribute_line_produc_product_attribute_line_id_pro_key", unique: true
    t.index ["product_attribute_line_id"], name: "product_attribute_line_product_at_product_attribute_line_id_idx"
    t.index ["product_attribute_value_id"], name: "product_attribute_line_product_a_product_attribute_value_id_idx"
  end

  create_table "product_attribute_price", id: :serial, comment: "product.attribute.price", force: :cascade do |t|
    t.integer "product_tmpl_id", null: false, comment: "Product Template"
    t.integer "value_id", null: false, comment: "Product Attribute Value"
    t.decimal "price_extra", comment: "Price Extra"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "product_attribute_value", id: :serial, comment: "product.attribute.value", force: :cascade do |t|
    t.string "name", null: false, comment: "Value"
    t.integer "sequence", comment: "Sequence"
    t.integer "attribute_id", null: false, comment: "Attribute"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name", "attribute_id"], name: "product_attribute_value_value_company_uniq", unique: true
  end

  create_table "product_attribute_value_product_product_rel", id: false, comment: "RELATION BETWEEN product_product AND product_attribute_value", force: :cascade do |t|
    t.integer "product_product_id", null: false
    t.integer "product_attribute_value_id", null: false
    t.index ["product_attribute_value_id"], name: "product_attribute_value_product__product_attribute_value_id_idx"
    t.index ["product_product_id", "product_attribute_value_id"], name: "product_attribute_value_produ_product_product_id_product_at_key", unique: true
    t.index ["product_product_id"], name: "product_attribute_value_product_product__product_product_id_idx"
  end

  create_table "product_category", id: :serial, comment: "Product Category", force: :cascade do |t|
    t.integer "parent_left"
    t.integer "parent_right"
    t.string "name", null: false, comment: "Name"
    t.string "complete_name", comment: "Complete Name"
    t.integer "parent_id", comment: "Parent Category"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "product_category_name_index"
    t.index ["parent_id"], name: "product_category_parent_id_index"
    t.index ["parent_left"], name: "product_category_parent_left_index"
    t.index ["parent_right"], name: "product_category_parent_right_index"
  end

  create_table "product_margin", id: :serial, comment: "Product Margin", force: :cascade do |t|
    t.date "from_date", comment: "From"
    t.date "to_date", comment: "To"
    t.string "invoice_state", null: false, comment: "Invoice State"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["invoice_state"], name: "product_margin_invoice_state_index"
  end

  create_table "product_packaging", id: :serial, comment: "Packaging", force: :cascade do |t|
    t.string "name", null: false, comment: "Package Type"
    t.integer "sequence", comment: "Sequence"
    t.integer "product_id", comment: "Product"
    t.float "qty", comment: "Quantity per Package"
    t.string "barcode", comment: "Barcode"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "product_price_history", id: :serial, comment: "product.price.history", force: :cascade do |t|
    t.integer "company_id", null: false, comment: "Company"
    t.integer "product_id", null: false, comment: "Product"
    t.datetime "datetime", comment: "Date"
    t.decimal "cost", comment: "Cost"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "product_price_list", id: :serial, comment: "Price List", force: :cascade do |t|
    t.integer "price_list", null: false, comment: "PriceList"
    t.integer "qty1", comment: "Quantity-1"
    t.integer "qty2", comment: "Quantity-2"
    t.integer "qty3", comment: "Quantity-3"
    t.integer "qty4", comment: "Quantity-4"
    t.integer "qty5", comment: "Quantity-5"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "product_pricelist", id: :serial, comment: "Pricelist", force: :cascade do |t|
    t.string "name", null: false, comment: "Pricelist Name"
    t.boolean "active", comment: "Active"
    t.integer "currency_id", null: false, comment: "Currency"
    t.integer "company_id", comment: "Company"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "discount_policy", comment: "Discount Policy"
    t.integer "website_id", comment: "website"
  end

  create_table "product_pricelist_item", id: :serial, comment: "Pricelist item", force: :cascade do |t|
    t.integer "product_tmpl_id", comment: "Product Template"
    t.integer "product_id", comment: "Product"
    t.integer "categ_id", comment: "Product Category"
    t.integer "min_quantity", comment: "Min. Quantity"
    t.string "applied_on", null: false, comment: "Apply On"
    t.string "base", null: false, comment: "Based on"
    t.integer "base_pricelist_id", comment: "Other Pricelist"
    t.integer "pricelist_id", comment: "Pricelist"
    t.decimal "price_surcharge", comment: "Price Surcharge"
    t.decimal "price_discount", comment: "Price Discount"
    t.decimal "price_round", comment: "Price Rounding"
    t.decimal "price_min_margin", comment: "Min. Price Margin"
    t.decimal "price_max_margin", comment: "Max. Price Margin"
    t.integer "company_id", comment: "Company"
    t.integer "currency_id", comment: "Currency"
    t.date "date_start", comment: "Start Date"
    t.date "date_end", comment: "End Date"
    t.string "compute_price", comment: "Compute Price"
    t.decimal "fixed_price", comment: "Fixed Price"
    t.float "percent_price", comment: "Percentage Price"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["compute_price"], name: "product_pricelist_item_compute_price_index"
    t.index ["pricelist_id"], name: "product_pricelist_item_pricelist_id_index"
  end

  create_table "product_product", id: :serial, comment: "Product", force: :cascade do |t|
    t.string "default_code", comment: "Internal Reference"
    t.boolean "active", comment: "Active"
    t.integer "product_tmpl_id", null: false, comment: "Product Template"
    t.string "barcode", comment: "Barcode"
    t.float "volume", comment: "Volume"
    t.decimal "weight", comment: "Weight"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.index ["barcode"], name: "product_product_barcode_uniq", unique: true
    t.index ["default_code"], name: "product_product_default_code_index"
    t.index ["product_tmpl_id"], name: "product_product_product_tmpl_id_index"
  end

  create_table "product_supplier_taxes_rel", id: false, comment: "RELATION BETWEEN product_template AND account_tax", force: :cascade do |t|
    t.integer "prod_id", null: false
    t.integer "tax_id", null: false
    t.index ["prod_id", "tax_id"], name: "product_supplier_taxes_rel_prod_id_tax_id_key", unique: true
    t.index ["prod_id"], name: "product_supplier_taxes_rel_prod_id_idx"
    t.index ["tax_id"], name: "product_supplier_taxes_rel_tax_id_idx"
  end

  create_table "product_supplierinfo", id: :serial, comment: "Information about a product vendor", force: :cascade do |t|
    t.integer "name", null: false, comment: "Vendor"
    t.string "product_name", comment: "Vendor Product Name"
    t.string "product_code", comment: "Vendor Product Code"
    t.integer "sequence", comment: "Sequence"
    t.float "min_qty", null: false, comment: "Minimal Quantity"
    t.decimal "price", null: false, comment: "Price"
    t.integer "company_id", comment: "Company"
    t.integer "currency_id", null: false, comment: "Currency"
    t.date "date_start", comment: "Start Date"
    t.date "date_end", comment: "End Date"
    t.integer "product_id", comment: "Product Variant"
    t.integer "product_tmpl_id", comment: "Product Template"
    t.integer "delay", null: false, comment: "Delivery Lead Time"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["company_id"], name: "product_supplierinfo_company_id_index"
    t.index ["product_tmpl_id"], name: "product_supplierinfo_product_tmpl_id_index"
  end

  create_table "product_taxes_rel", id: false, comment: "RELATION BETWEEN product_template AND account_tax", force: :cascade do |t|
    t.integer "prod_id", null: false
    t.integer "tax_id", null: false
    t.index ["prod_id", "tax_id"], name: "product_taxes_rel_prod_id_tax_id_key", unique: true
    t.index ["prod_id"], name: "product_taxes_rel_prod_id_idx"
    t.index ["tax_id"], name: "product_taxes_rel_tax_id_idx"
  end

  create_table "product_template", id: :serial, comment: "Product Template", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "sequence", comment: "Sequence"
    t.text "description", comment: "Description"
    t.text "description_purchase", comment: "Purchase Description"
    t.text "description_sale", comment: "Sale Description"
    t.string "type", null: false, comment: "Product Type"
    t.boolean "rental", comment: "Can be Rent"
    t.integer "categ_id", null: false, comment: "Internal Category"
    t.decimal "list_price", comment: "Sales Price"
    t.float "volume", comment: "Volume"
    t.decimal "weight", comment: "Weight"
    t.boolean "sale_ok", comment: "Can be Sold"
    t.boolean "purchase_ok", comment: "Can be Purchased"
    t.integer "uom_id", null: false, comment: "Unit of Measure"
    t.integer "uom_po_id", null: false, comment: "Purchase Unit of Measure"
    t.integer "company_id", comment: "Company"
    t.boolean "active", comment: "Active"
    t.integer "color", comment: "Color Index"
    t.string "default_code", comment: "Internal Reference"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "service_type", comment: "Track Service"
    t.string "sale_line_warn", null: false, comment: "Sales Order Line"
    t.text "sale_line_warn_msg", comment: "Message for Sales Order Line"
    t.string "expense_policy", comment: "Re-Invoice Expenses"
    t.string "invoice_policy", comment: "Invoicing Policy"
    t.integer "email_template_id", comment: "Product Email Template"
    t.text "website_description", comment: "Description for the website"
    t.string "website_meta_title", comment: "Website meta title"
    t.text "website_meta_description", comment: "Website meta description"
    t.string "website_meta_keywords", comment: "Website meta keywords"
    t.boolean "website_published", comment: "Visible in Website"
    t.float "rating_last_value", comment: "Rating Last Value"
    t.boolean "can_be_expensed", comment: "Can be Expensed"
    t.boolean "available_in_pos", comment: "Available in Point of Sale"
    t.boolean "to_weight", comment: "To Weigh With Scale"
    t.integer "pos_categ_id", comment: "Point of Sale Category"
    t.string "service_tracking", comment: "Service Tracking"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.index ["company_id"], name: "product_template_company_id_index"
    t.index ["name"], name: "product_template_name_index"
  end

  create_table "product_uom", id: :serial, comment: "Product Unit of Measure", force: :cascade do |t|
    t.string "name", null: false, comment: "Unit of Measure"
    t.integer "category_id", null: false, comment: "Category"
    t.decimal "factor", null: false, comment: "Ratio"
    t.decimal "rounding", null: false, comment: "Rounding Precision"
    t.boolean "active", comment: "Active"
    t.string "uom_type", null: false, comment: "Type"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "product_uom_categ", id: :serial, comment: "Product UoM Categories", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "is_pos_groupable", comment: "Group Products in POS"
  end

  create_table "project_favorite_user_rel", id: false, comment: "RELATION BETWEEN project_project AND res_users", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.index ["project_id", "user_id"], name: "project_favorite_user_rel_project_id_user_id_key", unique: true
    t.index ["project_id"], name: "project_favorite_user_rel_project_id_idx"
    t.index ["user_id"], name: "project_favorite_user_rel_user_id_idx"
  end

  create_table "project_project", id: :serial, comment: "Project", force: :cascade do |t|
    t.boolean "active", comment: "Active"
    t.integer "sequence", comment: "Sequence"
    t.integer "analytic_account_id", null: false, comment: "Contract/Analytic"
    t.string "label_tasks", comment: "Use Tasks as"
    t.integer "resource_calendar_id", comment: "Working Time"
    t.integer "color", comment: "Color Index"
    t.integer "user_id", comment: "Project Manager"
    t.integer "alias_id", null: false, comment: "Alias"
    t.string "privacy_visibility", null: false, comment: "Privacy"
    t.date "date_start", comment: "Start Date"
    t.date "date", comment: "Expiration Date"
    t.integer "subtask_project_id", comment: "Sub-task Project"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "allow_timesheets", comment: "Allow timesheets"
    t.integer "sale_line_id", comment: "Sales Order Line"
    t.index ["date"], name: "project_project_date_index"
  end

  create_table "project_tags", id: :serial, comment: "Tags of project's tasks", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "color", comment: "Color Index"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "project_tags_name_uniq", unique: true
  end

  create_table "project_tags_project_task_rel", id: false, comment: "RELATION BETWEEN project_task AND project_tags", force: :cascade do |t|
    t.integer "project_task_id", null: false
    t.integer "project_tags_id", null: false
    t.index ["project_tags_id"], name: "project_tags_project_task_rel_project_tags_id_idx"
    t.index ["project_task_id", "project_tags_id"], name: "project_tags_project_task_rel_project_task_id_project_tags__key", unique: true
    t.index ["project_task_id"], name: "project_tags_project_task_rel_project_task_id_idx"
  end

  create_table "project_task", id: :serial, comment: "Task", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.boolean "active", comment: "Active"
    t.string "name", null: false, comment: "Task Title"
    t.text "description", comment: "Description"
    t.string "priority", comment: "Priority"
    t.integer "sequence", comment: "Sequence"
    t.integer "stage_id", comment: "Stage"
    t.string "kanban_state", null: false, comment: "Kanban State"
    t.datetime "create_date", comment: "Create Date"
    t.datetime "write_date", comment: "Write Date"
    t.datetime "date_start", comment: "Starting Date"
    t.datetime "date_end", comment: "Ending Date"
    t.datetime "date_assign", comment: "Assigning Date"
    t.date "date_deadline", comment: "Deadline"
    t.datetime "date_last_stage_update", comment: "Last Stage Update"
    t.integer "project_id", comment: "Project"
    t.text "notes", comment: "Notes"
    t.float "planned_hours", comment: "Initially Planned Hours"
    t.decimal "remaining_hours", comment: "Remaining Hours"
    t.integer "user_id", comment: "Assigned to"
    t.integer "partner_id", comment: "Customer"
    t.integer "company_id", comment: "Company"
    t.integer "color", comment: "Color Index"
    t.integer "displayed_image_id", comment: "Cover Image"
    t.integer "parent_id", comment: "Parent Task"
    t.string "email_from", comment: "Email"
    t.string "email_cc", comment: "Watchers Emails"
    t.float "working_hours_open", comment: "Working hours to assign"
    t.float "working_hours_close", comment: "Working hours to close"
    t.float "working_days_open", comment: "Working days to assign"
    t.float "working_days_close", comment: "Working days to close"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.float "effective_hours", comment: "Hours Spent"
    t.float "total_hours", comment: "Total"
    t.float "total_hours_spent", comment: "Total Hours"
    t.float "progress", comment: "Progress"
    t.float "delay_hours", comment: "Delay Hours"
    t.float "children_hours", comment: "Sub-tasks Hours"
    t.float "rating_last_value", comment: "Rating Last Value"
    t.integer "sale_line_id", comment: "Sales Order Item"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.index ["create_date"], name: "project_task_create_date_index"
    t.index ["date_assign"], name: "project_task_date_assign_index"
    t.index ["date_deadline"], name: "project_task_date_deadline_index"
    t.index ["date_end"], name: "project_task_date_end_index"
    t.index ["date_last_stage_update"], name: "project_task_date_last_stage_update_index"
    t.index ["date_start"], name: "project_task_date_start_index"
    t.index ["email_from"], name: "project_task_email_from_index"
    t.index ["name"], name: "project_task_name_index"
    t.index ["parent_id"], name: "project_task_parent_id_index"
    t.index ["priority"], name: "project_task_priority_index"
    t.index ["project_id"], name: "project_task_project_id_index"
    t.index ["sequence"], name: "project_task_sequence_index"
    t.index ["stage_id"], name: "project_task_stage_id_index"
    t.index ["user_id"], name: "project_task_user_id_index"
    t.index ["write_date"], name: "project_task_write_date_index"
  end

  create_table "project_task_merge_wizard", id: :serial, comment: "project.task.merge.wizard", force: :cascade do |t|
    t.integer "user_id", comment: "Assigned to"
    t.boolean "create_new_task", comment: "Create a new task"
    t.string "target_task_name", comment: "New task name"
    t.integer "target_project_id", comment: "Target Project"
    t.integer "target_task_id", comment: "Merge into an existing task"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "project_task_project_task_merge_wizard_rel", id: false, comment: "RELATION BETWEEN project_task_merge_wizard AND project_task", force: :cascade do |t|
    t.integer "project_task_merge_wizard_id", null: false
    t.integer "project_task_id", null: false
    t.index ["project_task_id"], name: "project_task_project_task_merge_wizard_rel_project_task_id_idx"
    t.index ["project_task_merge_wizard_id", "project_task_id"], name: "project_task_project_task_mer_project_task_merge_wizard_id__key", unique: true
    t.index ["project_task_merge_wizard_id"], name: "project_task_project_task_merg_project_task_merge_wizard_id_idx"
  end

  create_table "project_task_type", id: :serial, comment: "Task Stage", force: :cascade do |t|
    t.string "name", null: false, comment: "Stage Name"
    t.text "description", comment: "Description"
    t.integer "sequence", comment: "Sequence"
    t.string "legend_priority", comment: "Starred Explanation"
    t.string "legend_blocked", null: false, comment: "Red Kanban Label"
    t.string "legend_done", null: false, comment: "Green Kanban Label"
    t.string "legend_normal", null: false, comment: "Grey Kanban Label"
    t.integer "mail_template_id", comment: "Email Template"
    t.boolean "fold", comment: "Folded in Kanban"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "project_task_type_rel", id: false, comment: "RELATION BETWEEN project_task_type AND project_project", force: :cascade do |t|
    t.integer "type_id", null: false
    t.integer "project_id", null: false
    t.index ["project_id"], name: "project_task_type_rel_project_id_idx"
    t.index ["type_id", "project_id"], name: "project_task_type_rel_type_id_project_id_key", unique: true
    t.index ["type_id"], name: "project_task_type_rel_type_id_idx"
  end

  create_table "question_choices", force: :cascade do |t|
    t.bigint "question_id"
    t.boolean "is_right_choice"
    t.string "choice_content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_question_choices_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "op_lession_id"
    t.text "question"
    t.string "question_type"
    t.boolean "is_active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["op_lession_id"], name: "index_questions_on_op_lession_id"
  end

  create_table "rating_rating", id: :serial, comment: "Rating", force: :cascade do |t|
    t.string "res_name", comment: "Resource name"
    t.integer "res_model_id", comment: "Related Document Model"
    t.string "res_model", comment: "Document Model"
    t.integer "res_id", null: false, comment: "Document"
    t.string "parent_res_name", comment: "Parent Document Name"
    t.integer "parent_res_model_id", comment: "Parent Related Document Model"
    t.string "parent_res_model", comment: "Parent Document Model"
    t.integer "parent_res_id", comment: "Parent Document"
    t.integer "rated_partner_id", comment: "Rated person"
    t.integer "partner_id", comment: "Customer"
    t.float "rating", comment: "Rating"
    t.string "rating_text", comment: "Rating"
    t.text "feedback", comment: "Comment"
    t.integer "message_id", comment: "Linked message"
    t.string "access_token", comment: "Security Token"
    t.boolean "consumed", comment: "Filled Rating"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "website_published", comment: "Published"
    t.index ["message_id"], name: "rating_rating_message_id_index"
    t.index ["parent_res_id"], name: "rating_rating_parent_res_id_index"
    t.index ["parent_res_model"], name: "rating_rating_parent_res_model_index"
    t.index ["parent_res_model_id"], name: "rating_rating_parent_res_model_id_index"
    t.index ["res_id"], name: "rating_rating_res_id_index"
    t.index ["res_model"], name: "rating_rating_res_model_index"
    t.index ["res_model_id"], name: "rating_rating_res_model_id_index"
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "type", null: false
    t.bigint "post_id", null: false
    t.string "post_type", limit: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_reactions_on_post_id"
    t.index ["post_type"], name: "index_reactions_on_post_type"
  end

  create_table "recruitment_source", id: :serial, comment: "Recruitment Source", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.text "note", comment: "Note"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
  end

  create_table "redeem_products", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.decimal "price", precision: 10, scale: 2
    t.integer "category", null: false
    t.string "available_color", limit: 255
    t.string "available_size", limit: 255
    t.string "brand", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category"], name: "index_redeem_products_on_category"
    t.index ["name"], name: "index_redeem_products_on_name"
  end

  create_table "redeem_transactions", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "redeem_product_id", null: false
    t.string "color", limit: 255, null: false
    t.integer "size"
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "total_paid", precision: 10, scale: 2
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["redeem_product_id"], name: "index_redeem_transactions_on_redeem_product_id"
    t.index ["student_id"], name: "index_redeem_transactions_on_student_id"
  end

  create_table "rel_badge_auth_users", id: false, comment: "RELATION BETWEEN gamification_badge AND res_users", force: :cascade do |t|
    t.integer "gamification_badge_id", null: false
    t.integer "res_users_id", null: false
    t.index ["gamification_badge_id", "res_users_id"], name: "rel_badge_auth_users_gamification_badge_id_res_users_id_key", unique: true
    t.index ["gamification_badge_id"], name: "rel_badge_auth_users_gamification_badge_id_idx"
    t.index ["res_users_id"], name: "rel_badge_auth_users_res_users_id_idx"
  end

  create_table "rel_channel_groups", id: false, comment: "RELATION BETWEEN slide_channel AND res_groups", force: :cascade do |t|
    t.integer "channel_id", null: false
    t.integer "group_id", null: false
    t.index ["channel_id", "group_id"], name: "rel_channel_groups_channel_id_group_id_key", unique: true
    t.index ["channel_id"], name: "rel_channel_groups_channel_id_idx"
    t.index ["group_id"], name: "rel_channel_groups_group_id_idx"
  end

  create_table "rel_modules_langexport", id: false, comment: "RELATION BETWEEN base_language_export AND ir_module_module", force: :cascade do |t|
    t.integer "wiz_id", null: false
    t.integer "module_id", null: false
    t.index ["module_id"], name: "rel_modules_langexport_module_id_idx"
    t.index ["wiz_id", "module_id"], name: "rel_modules_langexport_wiz_id_module_id_key", unique: true
    t.index ["wiz_id"], name: "rel_modules_langexport_wiz_id_idx"
  end

  create_table "rel_server_actions", id: false, comment: "RELATION BETWEEN ir_act_server AND ir_act_server", force: :cascade do |t|
    t.integer "server_id", null: false
    t.integer "action_id", null: false
    t.index ["action_id"], name: "rel_server_actions_action_id_idx"
    t.index ["server_id", "action_id"], name: "rel_server_actions_server_id_action_id_key", unique: true
    t.index ["server_id"], name: "rel_server_actions_server_id_idx"
  end

  create_table "rel_slide_tag", id: false, comment: "RELATION BETWEEN slide_slide AND slide_tag", force: :cascade do |t|
    t.integer "slide_id", null: false
    t.integer "tag_id", null: false
    t.index ["slide_id", "tag_id"], name: "rel_slide_tag_slide_id_tag_id_key", unique: true
    t.index ["slide_id"], name: "rel_slide_tag_slide_id_idx"
    t.index ["tag_id"], name: "rel_slide_tag_tag_id_idx"
  end

  create_table "rel_upload_groups", id: false, comment: "RELATION BETWEEN slide_channel AND res_groups", force: :cascade do |t|
    t.integer "channel_id", null: false
    t.integer "group_id", null: false
    t.index ["channel_id", "group_id"], name: "rel_upload_groups_channel_id_group_id_key", unique: true
    t.index ["channel_id"], name: "rel_upload_groups_channel_id_idx"
    t.index ["group_id"], name: "rel_upload_groups_group_id_idx"
  end

  create_table "remove_draft_session", id: :serial, comment: "remove.draft.session", force: :cascade do |t|
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.string "remove_text", comment: "Xác nhận xóa tất cả các Sesion"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "report_paperformat", id: :serial, comment: "Allows customization of a report.", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.boolean "default", comment: "Default paper format ?"
    t.string "format", comment: "Paper size"
    t.float "margin_top", comment: "Top Margin (mm)"
    t.float "margin_bottom", comment: "Bottom Margin (mm)"
    t.float "margin_left", comment: "Left Margin (mm)"
    t.float "margin_right", comment: "Right Margin (mm)"
    t.integer "page_height", comment: "Page height (mm)"
    t.integer "page_width", comment: "Page width (mm)"
    t.string "orientation", comment: "Orientation"
    t.boolean "header_line", comment: "Display a header line"
    t.integer "header_spacing", comment: "Header spacing"
    t.integer "dpi", null: false, comment: "Output DPI"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_bank", id: :serial, comment: "Bank", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "street", comment: "Street"
    t.string "street2", comment: "Street2"
    t.string "zip", comment: "Zip"
    t.string "city", comment: "City"
    t.integer "state", comment: "Fed. State"
    t.integer "country", comment: "Country"
    t.string "email", comment: "Email"
    t.string "phone", comment: "Phone"
    t.boolean "active", comment: "Active"
    t.string "bic", comment: "Bank Identifier Code"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["bic"], name: "res_bank_bic_index"
  end

  create_table "res_company", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "partner_id", null: false
    t.integer "currency_id", null: false
    t.integer "sequence", comment: "Sequence"
    t.integer "parent_id", comment: "Parent Company"
    t.text "report_header", comment: "Company Tagline"
    t.text "report_footer", comment: "Report Footer"
    t.binary "logo_web", comment: "Logo Web"
    t.string "account_no", comment: "Account No."
    t.string "email", comment: "Email"
    t.string "phone", comment: "Phone"
    t.string "company_registry", comment: "Company Registry"
    t.integer "paperformat_id", comment: "Paper format"
    t.string "external_report_layout", comment: "Document Template"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "resource_calendar_id", comment: "Default Working Hours"
    t.string "social_twitter", comment: "Twitter Account"
    t.string "social_facebook", comment: "Facebook Account"
    t.string "social_github", comment: "GitHub Account"
    t.string "social_linkedin", comment: "LinkedIn Account"
    t.string "social_youtube", comment: "Youtube Account"
    t.string "social_googleplus", comment: "Google+ Account"
    t.integer "fiscalyear_last_day", null: false, comment: "Fiscalyear Last Day"
    t.integer "fiscalyear_last_month", null: false, comment: "Fiscalyear Last Month"
    t.date "period_lock_date", comment: "Lock Date for Non-Advisers"
    t.date "fiscalyear_lock_date", comment: "Lock Date"
    t.integer "transfer_account_id", comment: "Inter-Banks Transfer Account"
    t.boolean "expects_chart_of_accounts", comment: "Expects a Chart of Accounts"
    t.integer "chart_template_id", comment: "Chart Template"
    t.string "bank_account_code_prefix", comment: "Prefix of the bank accounts"
    t.string "cash_account_code_prefix", comment: "Prefix of the cash accounts"
    t.integer "accounts_code_digits", comment: "Number of digits in an account code"
    t.integer "tax_cash_basis_journal_id", comment: "Cash Basis Journal"
    t.string "tax_calculation_rounding_method", comment: "Tax Calculation Rounding Method"
    t.integer "currency_exchange_journal_id", comment: "Exchange Gain or Loss Journal"
    t.boolean "anglo_saxon_accounting", comment: "Use anglo-saxon accounting"
    t.integer "property_stock_account_input_categ_id", comment: "Input Account for Stock Valuation"
    t.integer "property_stock_account_output_categ_id", comment: "Output Account for Stock Valuation"
    t.integer "property_stock_valuation_account_id", comment: "Account Template for Stock Valuation"
    t.text "overdue_msg", comment: "Overdue Payments Message"
    t.boolean "tax_exigibility", comment: "Use Cash Basis"
    t.integer "account_opening_move_id", comment: "Opening Journal Entry"
    t.boolean "account_setup_company_data_done", comment: "Company Setup Marked As Done"
    t.boolean "account_setup_bank_data_done", comment: "Bank Setup Marked As Done"
    t.boolean "account_setup_fy_data_done", comment: "Financial Year Setup Marked As Done"
    t.boolean "account_setup_coa_done", comment: "Chart of Account Checked"
    t.boolean "account_setup_bar_closed", comment: "Setup Bar Closed"
    t.text "sale_note", comment: "Default Terms and Conditions"
    t.boolean "vat_check_vies", comment: "Verify VAT Numbers"
    t.binary "signature", comment: "Signature"
    t.text "accreditation", comment: "Accreditation"
    t.text "approval_authority", comment: "Approval Authority"
    t.string "openeducat_instance_key", comment: "OpenEducat Instance Key"
    t.string "openeducat_instance_hash_key", comment: "OpenEducat Instance Hash Key"
    t.boolean "is_mail_sent", comment: "Is Mail Sent"
    t.string "verify_date", comment: "Verify Date"
    t.string "openeducat_instance_hash_msg", comment: "Instance Hash Key Message"
    t.integer "project_time_mode_id", comment: "Project Time Unit"
    t.integer "leave_timesheet_project_id", comment: "Internal Project"
    t.integer "leave_timesheet_task_id", comment: "Leave Task"
    t.string "pad_key", comment: "Pad Api Key"
    t.text "cc", comment: "Mail CC"
    t.string "code", comment: "Code"
    t.string "kanban_state", comment: "Kanban color"
    t.index ["name"], name: "res_company_name_uniq", unique: true
    t.index ["parent_id"], name: "res_company_parent_id_index"
  end

  create_table "res_company_users_rel", id: false, comment: "RELATION BETWEEN res_company AND res_users", force: :cascade do |t|
    t.integer "cid", null: false
    t.integer "user_id", null: false
    t.index ["cid", "user_id"], name: "res_company_users_rel_cid_user_id_key", unique: true
    t.index ["cid"], name: "res_company_users_rel_cid_idx"
    t.index ["user_id"], name: "res_company_users_rel_user_id_idx"
  end

  create_table "res_config", id: :serial, comment: "res.config", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_config_installer", id: :serial, comment: "res.config.installer", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_config_settings", id: :serial, comment: "res.config.settings", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "group_multi_company", comment: "Manage multiple companies"
    t.integer "company_id", null: false, comment: "Company"
    t.boolean "default_user_rights", comment: "Default Access Rights"
    t.boolean "default_external_email_server", comment: "External Email Servers"
    t.boolean "module_base_import", comment: "Allow users to import data from CSV/XLS/XLSX/ODS files"
    t.boolean "module_google_calendar", comment: "Allow the users to synchronize their calendar  with Google Calendar"
    t.boolean "module_google_drive", comment: "Attach Google documents to any record"
    t.boolean "module_google_spreadsheet", comment: "Google Spreadsheet"
    t.boolean "module_auth_oauth", comment: "Use external authentication providers (OAuth)"
    t.boolean "module_auth_ldap", comment: "LDAP Authentication"
    t.boolean "module_base_gengo", comment: "Translate Your Website with Gengo"
    t.boolean "module_inter_company_rules", comment: "Manage Inter Company"
    t.boolean "module_pad", comment: "Collaborative Pads"
    t.boolean "module_voip", comment: "Asterisk (VoIP)"
    t.boolean "company_share_partner", comment: "Share partners to all companies"
    t.boolean "default_custom_report_footer", comment: "Custom Report Footer"
    t.boolean "group_multi_currency", comment: "Multi-Currencies"
    t.integer "fail_counter", comment: "Fail Mail"
    t.string "alias_domain", comment: "Alias Domain"
    t.boolean "auth_signup_reset_password", comment: "Enable password reset from Login page"
    t.string "auth_signup_uninvited", comment: "Customer Account"
    t.integer "auth_signup_template_user_id", comment: "Template user for new users created through signup"
    t.string "crm_alias_prefix", comment: "Default Alias Name for Leads"
    t.boolean "generate_lead_from_alias", comment: "Manual Assignation of Emails"
    t.boolean "group_use_lead", comment: "Leads"
    t.boolean "module_crm_phone_validation", comment: "Phone Formatting"
    t.boolean "module_web_clearbit", comment: "Customer Autocomplete"
    t.boolean "module_hr_org_chart", comment: "Show Organizational Chart"
    t.boolean "group_mass_mailing_campaign", comment: "Mass Mailing Campaigns"
    t.boolean "company_share_product", comment: "Share product to all companies"
    t.boolean "group_uom", comment: "Units of Measure"
    t.boolean "group_product_variant", comment: "Attributes and Variants"
    t.boolean "group_stock_packaging", comment: "Product Packages"
    t.boolean "group_sale_pricelist", comment: "Use pricelists to adapt your price per customers"
    t.boolean "group_product_pricelist", comment: "Show pricelists On Products"
    t.boolean "group_pricelist_item", comment: "Show pricelists to customers"
    t.integer "chart_template_id", comment: "Template"
    t.boolean "module_account_accountant", comment: "Accounting"
    t.boolean "group_analytic_accounting", comment: "Analytic Accounting"
    t.boolean "group_warning_account", comment: "Warnings"
    t.boolean "group_cash_rounding", comment: "Cash Rounding"
    t.boolean "module_account_asset", comment: "Assets Management"
    t.boolean "module_account_deferred_revenue", comment: "Revenue Recognition"
    t.boolean "module_account_budget", comment: "Budget Management"
    t.boolean "module_account_payment", comment: "Online Payment"
    t.boolean "module_account_reports", comment: "Dynamic Reports"
    t.boolean "module_account_reports_followup", comment: "Follow-up Levels"
    t.boolean "module_l10n_us_check_printing", comment: "Allow check printing and deposits"
    t.boolean "module_account_batch_deposit", comment: "Use batch deposit"
    t.boolean "module_account_sepa", comment: "SEPA Credit Transfer (SCT)"
    t.boolean "module_account_sepa_direct_debit", comment: "Use SEPA Direct Debit"
    t.boolean "module_account_plaid", comment: "Plaid Connector"
    t.boolean "module_account_yodlee", comment: "Bank Interface - Sync your bank feeds automatically"
    t.boolean "module_account_bank_statement_import_qif", comment: "Import .qif files"
    t.boolean "module_account_bank_statement_import_ofx", comment: "Import in .ofx format"
    t.boolean "module_account_bank_statement_import_csv", comment: "Import in .csv format"
    t.boolean "module_account_bank_statement_import_camt", comment: "Import in CAMT.053 format"
    t.boolean "module_currency_rate_live", comment: "Automatic Currency Rates"
    t.boolean "module_print_docsaway", comment: "Docsaway"
    t.boolean "module_product_margin", comment: "Allow Product Margin"
    t.boolean "module_l10n_eu_service", comment: "EU Digital Goods VAT"
    t.boolean "module_account_taxcloud", comment: "Account TaxCloud"
    t.boolean "use_sale_note", comment: "Default Terms & Conditions"
    t.boolean "group_discount_per_so_line", comment: "Discounts"
    t.boolean "module_sale_margin", comment: "Margins"
    t.boolean "group_sale_layout", comment: "Sections on Sales Orders"
    t.boolean "group_warning_sale", comment: "Warnings"
    t.boolean "portal_confirmation", comment: "Online Signature & Payment"
    t.string "portal_confirmation_options", comment: "Online Signature & Payment options"
    t.boolean "module_sale_payment", comment: "Online Signature & Payment"
    t.boolean "module_website_quote", comment: "Quotations Templates"
    t.boolean "group_sale_delivery_address", comment: "Customer Addresses"
    t.boolean "multi_sales_price", comment: "Multiple Sales Prices per Product"
    t.string "multi_sales_price_method", comment: "Pricelists"
    t.string "sale_pricelist_setting", comment: "Pricelists"
    t.boolean "group_show_price_subtotal", comment: "Show subtotal"
    t.boolean "group_show_price_total", comment: "Show total"
    t.boolean "group_proforma_sales", comment: "Pro-Forma Invoice"
    t.string "sale_show_tax", null: false, comment: "Tax Display"
    t.string "default_invoice_policy", comment: "Invoicing Policy"
    t.integer "default_deposit_product_id", comment: "Deposit Product"
    t.boolean "auto_done_setting", comment: "Lock Confirmed Orders"
    t.boolean "module_website_sale_digital", comment: "Sell digital products - provide downloadable content on your customer portal"
    t.boolean "module_delivery", comment: "Shipping Costs"
    t.boolean "module_product_email_template", comment: "Specific Email"
    t.boolean "module_sale_coupon", comment: "Coupons & Promotions"
    t.boolean "group_attendance_use_pin", comment: "Employee PIN"
    t.string "google_drive_authorization_code", comment: "Authorization Code"
    t.boolean "module_website_hr_recruitment", comment: "Online Posting"
    t.boolean "module_hr_recruitment_survey", comment: "Interview Forms"
    t.boolean "module_event_sale", comment: "Tickets"
    t.boolean "module_website_event_track", comment: "Tracks and Agenda"
    t.boolean "module_website_event_questions", comment: "Registration Survey"
    t.boolean "module_event_barcode", comment: "Barcode"
    t.boolean "module_website_event_sale", comment: "Online Ticketing"
    t.integer "website_id", null: false, comment: "website"
    t.boolean "module_website_version", comment: "A/B Testing"
    t.string "google_maps_api_key", comment: "Google Maps API Key"
    t.boolean "has_google_analytics", comment: "Google Analytics"
    t.boolean "has_google_analytics_dashboard", comment: "Google Analytics in Dashboard"
    t.boolean "has_google_maps", comment: "Google Maps"
    t.boolean "group_website_popup_on_exit", comment: "Website Popup"
    t.string "cal_client_id", comment: "Client_id"
    t.string "cal_client_secret", comment: "Client_key"
    t.string "server_uri", comment: "URI for tuto"
    t.string "expense_alias_prefix", comment: "Default Alias Name for Expenses"
    t.boolean "use_mailgateway", comment: "Let your employees record expenses by email"
    t.boolean "module_sale_management", comment: "Customer Billing"
    t.boolean "module_l10n_fr_hr_payroll", comment: "French Payroll"
    t.boolean "module_l10n_be_hr_payroll", comment: "Belgium Payroll"
    t.boolean "module_l10n_in_hr_payroll", comment: "Indian Payroll"
    t.boolean "auth_oauth_google_enabled", comment: "Allow users to sign in with Google"
    t.string "auth_oauth_google_client_id", comment: "Client ID"
    t.string "server_uri_google", comment: "Server uri"
    t.string "website_slide_google_app_key", comment: "Google Doc Key"
    t.boolean "module_delivery_dhl", comment: "DHL"
    t.boolean "module_delivery_fedex", comment: "FedEx"
    t.boolean "module_delivery_ups", comment: "UPS"
    t.boolean "module_delivery_usps", comment: "USPS"
    t.boolean "module_delivery_bpost", comment: "bpost"
    t.boolean "module_hr_timesheet", comment: "Timesheets"
    t.boolean "module_rating_project", comment: "Rating on Tasks"
    t.boolean "module_project_forecast", comment: "Forecasts"
    t.boolean "group_subtask_project", comment: "Sub-tasks"
    t.boolean "module_project_timesheet_synchro", comment: "Awesome Timesheet"
    t.boolean "module_sale_timesheet", comment: "Time Billing"
    t.boolean "module_project_timesheet_holidays", comment: "Leaves"
    t.boolean "voip_enable", comment: "VoIP Phone Call"
    t.string "voip_domain", comment: "Domain"
    t.boolean "cdr_api_enable", comment: "Enable Phonenet.vn Api?"
    t.string "cdr_api_key", comment: "API Key"
    t.boolean "module_muk_web_client_refresh", comment: "Web Refresh"
    t.boolean "module_muk_web_client_notification", comment: "Web Notification"
    t.boolean "module_document", comment: "Attachments List and Document Indexation"
    t.boolean "group_ir_attachment_user", comment: "Central access to Documents"
    t.boolean "module_document_page", comment: "Manage document pages (Wiki)"
    t.boolean "module_document_page_approval", comment: "Manage documents approval"
    t.boolean "module_cmis_read", comment: "Attach files from an external DMS into Odoo"
    t.boolean "module_cmis_write", comment: "Store attachments in an external DMS instead of the Odoo Filestore"
    t.integer "student_test_survey_id", comment: "Student Test Survey"
    t.integer "default_survey_id", comment: "Default Survey"
  end

  create_table "res_country", id: :serial, comment: "Country", force: :cascade do |t|
    t.string "name", null: false, comment: "Country Name"
    t.string "code", limit: 2, comment: "Country Code"
    t.text "address_format", comment: "Layout in Reports"
    t.integer "address_view_id", comment: "Input View"
    t.integer "currency_id", comment: "Currency"
    t.integer "phone_code", comment: "Country Calling Code"
    t.string "name_position", comment: "Customer Name Position"
    t.string "vat_label", comment: "Vat Label"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "res_country_code_uniq", unique: true
    t.index ["name"], name: "res_country_name_uniq", unique: true
  end

  create_table "res_country_group", id: :serial, comment: "Country Group", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_country_group_pricelist_rel", id: false, comment: "RELATION BETWEEN product_pricelist AND res_country_group", force: :cascade do |t|
    t.integer "pricelist_id", null: false
    t.integer "res_country_group_id", null: false
    t.index ["pricelist_id", "res_country_group_id"], name: "res_country_group_pricelist_r_pricelist_id_res_country_grou_key", unique: true
    t.index ["pricelist_id"], name: "res_country_group_pricelist_rel_pricelist_id_idx"
    t.index ["res_country_group_id"], name: "res_country_group_pricelist_rel_res_country_group_id_idx"
  end

  create_table "res_country_res_country_group_rel", id: false, comment: "RELATION BETWEEN res_country AND res_country_group", force: :cascade do |t|
    t.integer "res_country_id", null: false
    t.integer "res_country_group_id", null: false
    t.index ["res_country_group_id"], name: "res_country_res_country_group_rel_res_country_group_id_idx"
    t.index ["res_country_id", "res_country_group_id"], name: "res_country_res_country_group_res_country_id_res_country_gr_key", unique: true
    t.index ["res_country_id"], name: "res_country_res_country_group_rel_res_country_id_idx"
  end

  create_table "res_country_state", id: :serial, comment: "Country state", force: :cascade do |t|
    t.integer "country_id", null: false, comment: "Country"
    t.string "name", null: false, comment: "State Name"
    t.string "code", null: false, comment: "State Code"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["country_id", "code"], name: "res_country_state_name_code_uniq", unique: true
  end

  create_table "res_currency", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "symbol", null: false
    t.decimal "rounding", comment: "Rounding Factor"
    t.boolean "active", comment: "Active"
    t.string "position", comment: "Symbol Position"
    t.string "currency_unit_label", comment: "Currency Unit"
    t.string "currency_subunit_label", comment: "Currency Subunit"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "res_currency_unique_name", unique: true
  end

  create_table "res_currency_rate", id: :serial, comment: "Currency Rate", force: :cascade do |t|
    t.date "name", null: false, comment: "Date"
    t.decimal "rate", comment: "Rate"
    t.integer "currency_id", comment: "Currency"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name", "currency_id", "company_id"], name: "res_currency_rate_unique_name_per_day", unique: true
    t.index ["name"], name: "res_currency_rate_name_index"
  end

  create_table "res_district", id: :serial, comment: "res.district", force: :cascade do |t|
    t.string "name", null: false, comment: "Tên quận / huyện"
    t.string "code", comment: "Mã"
    t.integer "type", comment: "Lọai"
    t.integer "position", comment: "Thứ tự"
    t.boolean "active", comment: "Kích hoạt"
    t.integer "province_id", comment: "Tỉnh / thành phố"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "sequence_code", comment: "Đầu mã KH"
    t.index ["province_id"], name: "res_district_province_id_index"
  end

  create_table "res_groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "comment", comment: "Comment"
    t.integer "category_id", comment: "Application"
    t.integer "color", comment: "Color Index"
    t.boolean "share", comment: "Share Group"
    t.boolean "is_portal", comment: "Portal"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["category_id", "name"], name: "res_groups_name_uniq", unique: true
    t.index ["category_id"], name: "res_groups_category_id_index"
  end

  create_table "res_groups_implied_rel", id: false, comment: "RELATION BETWEEN res_groups AND res_groups", force: :cascade do |t|
    t.integer "gid", null: false
    t.integer "hid", null: false
    t.index ["gid", "hid"], name: "res_groups_implied_rel_gid_hid_key", unique: true
    t.index ["gid"], name: "res_groups_implied_rel_gid_idx"
    t.index ["hid"], name: "res_groups_implied_rel_hid_idx"
  end

  create_table "res_groups_report_rel", id: false, comment: "RELATION BETWEEN ir_act_report_xml AND res_groups", force: :cascade do |t|
    t.integer "uid", null: false
    t.integer "gid", null: false
    t.index ["gid"], name: "res_groups_report_rel_gid_idx"
    t.index ["uid", "gid"], name: "res_groups_report_rel_uid_gid_key", unique: true
    t.index ["uid"], name: "res_groups_report_rel_uid_idx"
  end

  create_table "res_groups_users_rel", id: false, comment: "RELATION BETWEEN res_groups AND res_users", force: :cascade do |t|
    t.integer "gid", null: false
    t.integer "uid", null: false
    t.index ["gid", "uid"], name: "res_groups_users_rel_gid_uid_key", unique: true
    t.index ["gid"], name: "res_groups_users_rel_gid_idx"
    t.index ["uid"], name: "res_groups_users_rel_uid_idx"
  end

  create_table "res_lang", id: :serial, comment: "Languages", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "code", null: false, comment: "Locale Code"
    t.string "iso_code", comment: "ISO code"
    t.boolean "translatable", comment: "Translatable"
    t.boolean "active", comment: "Active"
    t.string "direction", null: false, comment: "Direction"
    t.string "date_format", null: false, comment: "Date Format"
    t.string "time_format", null: false, comment: "Time Format"
    t.string "grouping", null: false, comment: "Separator Format"
    t.string "decimal_point", null: false, comment: "Decimal Separator"
    t.string "thousands_sep", comment: "Thousands Separator"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["code"], name: "res_lang_code_uniq", unique: true
    t.index ["name"], name: "res_lang_name_uniq", unique: true
  end

  create_table "res_partner", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "company_id"
    t.string "display_name", comment: "Display Name"
    t.date "date", comment: "Date"
    t.integer "title", comment: "Title"
    t.integer "parent_id", comment: "Related Company"
    t.string "ref", comment: "Internal Reference"
    t.string "lang", comment: "Language"
    t.string "tz", comment: "Timezone"
    t.integer "user_id", comment: "Salesperson"
    t.string "vat", comment: "TIN"
    t.string "website", comment: "Website"
    t.text "comment", comment: "Notes"
    t.float "credit_limit", comment: "Credit Limit"
    t.string "barcode", comment: "Barcode"
    t.boolean "active", comment: "Active"
    t.boolean "customer", comment: "Is a Customer"
    t.boolean "supplier", comment: "Is a Vendor"
    t.boolean "employee", comment: "Employee"
    t.string "function", comment: "Job Position"
    t.string "type", comment: "Address Type"
    t.string "street", comment: "Street"
    t.string "street2", comment: "Street2"
    t.string "zip", comment: "Zip"
    t.string "city", comment: "City"
    t.integer "state_id", comment: "State"
    t.integer "country_id", comment: "Country"
    t.string "email", comment: "Email"
    t.string "phone", comment: "Phone"
    t.string "mobile", comment: "Mobile"
    t.boolean "is_company", comment: "Is a Company"
    t.integer "industry_id", comment: "Industry"
    t.integer "color", comment: "Color Index"
    t.boolean "partner_share", comment: "Share Partner"
    t.integer "commercial_partner_id", comment: "Commercial Entity"
    t.integer "commercial_partner_country_id", comment: "Country"
    t.string "commercial_company_name", comment: "Company Name Entity"
    t.string "company_name", comment: "Company Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.integer "message_bounce", comment: "Bounce"
    t.boolean "opt_out", comment: "Opt-Out"
    t.string "signup_token", comment: "Signup Token"
    t.string "signup_type", comment: "Signup Token Type"
    t.datetime "signup_expiration", comment: "Signup Expiration"
    t.datetime "calendar_last_notif_ack", comment: "Last notification marked as read from base Calendar"
    t.integer "team_id", comment: "Sales Channel"
    t.decimal "debit_limit", comment: "Payable Limit"
    t.datetime "last_time_entries_checked", comment: "Latest Invoices & Payments Matching Date"
    t.string "invoice_warn", null: false, comment: "Invoice"
    t.text "invoice_warn_msg", comment: "Message for Invoice"
    t.string "sale_warn", null: false, comment: "Sales Order"
    t.text "sale_warn_msg", comment: "Message for Sales Order"
    t.text "website_description", comment: "Website Partner Full Description"
    t.text "website_short_description", comment: "Website Partner Short Description"
    t.string "website_meta_title", comment: "Website meta title"
    t.text "website_meta_description", comment: "Website meta description"
    t.string "website_meta_keywords", comment: "Website meta keywords"
    t.boolean "website_published", comment: "Visible in Website"
    t.boolean "is_venue", comment: "Venue"
    t.integer "province_id", comment: "Tỉnh - Thành phố"
    t.integer "district_id", comment: "Quận - Huyện"
    t.integer "ward_id", comment: "Xã - Phường"
    t.integer "tracking_emails_count"
    t.float "email_score"
    t.boolean "email_bounced", comment: "Email Bounced"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.index ["commercial_partner_id"], name: "res_partner_commercial_partner_id_index"
    t.index ["company_id"], name: "res_partner_company_id_index"
    t.index ["date"], name: "res_partner_date_index"
    t.index ["display_name"], name: "res_partner_display_name_index"
    t.index ["email_bounced"], name: "res_partner_email_bounced_index"
    t.index ["name"], name: "res_partner_name_index"
    t.index ["parent_id"], name: "res_partner_parent_id_index"
    t.index ["ref"], name: "res_partner_ref_index"
  end

  create_table "res_partner_bank", id: :serial, comment: "Bank Accounts", force: :cascade do |t|
    t.string "acc_number", null: false, comment: "Account Number"
    t.string "sanitized_acc_number", comment: "Sanitized Account Number"
    t.integer "partner_id", comment: "Account Holder"
    t.integer "bank_id", comment: "Bank"
    t.integer "sequence", comment: "Sequence"
    t.integer "currency_id", comment: "Currency"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["partner_id"], name: "res_partner_bank_partner_id_index"
    t.index ["sanitized_acc_number", "company_id"], name: "res_partner_bank_unique_number", unique: true
  end

  create_table "res_partner_category", id: :serial, comment: "Partner Tags", force: :cascade do |t|
    t.integer "parent_left"
    t.integer "parent_right"
    t.string "name", null: false, comment: "Tag Name"
    t.integer "color", comment: "Color Index"
    t.integer "parent_id", comment: "Parent Category"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["parent_id"], name: "res_partner_category_parent_id_index"
    t.index ["parent_left"], name: "res_partner_category_parent_left_index"
    t.index ["parent_right"], name: "res_partner_category_parent_right_index"
  end

  create_table "res_partner_industry", id: :serial, comment: "Industry", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.string "full_name", comment: "Full Name"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_partner_res_partner_category_rel", id: false, comment: "RELATION BETWEEN res_partner_category AND res_partner", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "partner_id", null: false
    t.index ["category_id", "partner_id"], name: "res_partner_res_partner_category_rel_category_id_partner_id_key", unique: true
    t.index ["category_id"], name: "res_partner_res_partner_category_rel_category_id_idx"
    t.index ["partner_id"], name: "res_partner_res_partner_category_rel_partner_id_idx"
  end

  create_table "res_partner_title", id: :serial, comment: "res.partner.title", force: :cascade do |t|
    t.string "name", null: false, comment: "Title"
    t.string "shortcut", comment: "Abbreviation"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_province", id: :serial, comment: "res.province", force: :cascade do |t|
    t.string "name", null: false, comment: "Tên tỉnh / thành phố"
    t.string "code", comment: "Mã"
    t.integer "type", comment: "Lọai"
    t.integer "position", comment: "Thứ tự"
    t.boolean "active", comment: "Kích hoạt"
    t.integer "country_id", comment: "Quốc gia"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "sequence_code", comment: "Đầu mã KH"
    t.index ["country_id"], name: "res_province_country_id_index"
  end

  create_table "res_request_link", id: :serial, comment: "res.request.link", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "object", null: false, comment: "Object"
    t.integer "priority", comment: "Priority"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_user_first_rel1", id: false, comment: "RELATION BETWEEN res_users AND res_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "res_user_second_rel1", null: false
    t.index ["res_user_second_rel1"], name: "res_user_first_rel1_res_user_second_rel1_idx"
    t.index ["user_id", "res_user_second_rel1"], name: "res_user_first_rel1_user_id_res_user_second_rel1_key", unique: true
    t.index ["user_id"], name: "res_user_first_rel1_user_id_idx"
  end

  create_table "res_users", id: :serial, force: :cascade do |t|
    t.boolean "active", default: true
    t.string "login", null: false
    t.string "password"
    t.integer "company_id", null: false
    t.integer "partner_id", null: false
    t.text "signature", comment: "Signature"
    t.integer "action_id", comment: "Home Action"
    t.boolean "share", comment: "Share User"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "password_crypt", comment: "Encrypted Password"
    t.integer "alias_id", comment: "Alias"
    t.string "notification_type", null: false, comment: "Notification Management"
    t.integer "sale_team_id", comment: "Sales Channel"
    t.integer "target_sales_won", comment: "Won in Opportunities Target"
    t.integer "target_sales_done", comment: "Activities Done Target"
    t.integer "target_sales_invoiced", comment: "Invoiced in Sales Orders Target"
    t.string "google_calendar_rtoken", comment: "Refresh Token"
    t.string "google_calendar_token", comment: "User token"
    t.datetime "google_calendar_token_validity", comment: "Token Validity"
    t.datetime "google_calendar_last_sync_date", comment: "Last synchro date"
    t.string "google_calendar_cal_id", comment: "Calendar ID"
    t.integer "oauth_provider_id", comment: "OAuth Provider"
    t.string "oauth_uid", comment: "OAuth User ID"
    t.string "oauth_access_token", comment: "OAuth Access Token"
    t.string "pos_security_pin", limit: 32, comment: "Security PIN"
    t.boolean "voip_enable", comment: "Enable VoIP Phone"
    t.string "voip_user", comment: "Account"
    t.string "voip_pw", comment: "Password"
    t.index ["login"], name: "res_users_login_key", unique: true
    t.index ["oauth_provider_id", "oauth_uid"], name: "res_users_uniq_users_oauth_provider_oauth_uid", unique: true
    t.index ["voip_user"], name: "res_users_voip_user_index"
    t.index ["voip_user"], name: "res_users_voip_user_unique", unique: true
  end

  create_table "res_users_log", id: :serial, comment: "res.users.log", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_users_role", id: :serial, comment: "User role", force: :cascade do |t|
    t.integer "group_id", null: false, comment: "Associated group"
    t.text "comment", comment: "Internal Notes"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_users_role_line", id: :serial, comment: "Users associated to a role", force: :cascade do |t|
    t.integer "role_id", comment: "Role"
    t.integer "user_id", comment: "User"
    t.date "date_from", comment: "From"
    t.date "date_to", comment: "To"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "res_ward", id: :serial, comment: "res.ward", force: :cascade do |t|
    t.string "name", null: false, comment: "Tên xã / phường"
    t.string "code", comment: "Mã"
    t.integer "type", comment: "Lọai"
    t.integer "position", comment: "Thứ tự"
    t.boolean "active", comment: "Kích hoạt"
    t.integer "district_id", comment: "Quận / huyện"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["district_id"], name: "res_ward_district_id_index"
  end

  create_table "reserve_media", id: :serial, comment: "reserve.media", force: :cascade do |t|
    t.integer "partner_id", null: false, comment: "Partner"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "resource_calendar", id: :serial, comment: "Resource Calendar", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "resource_calendar_attendance", id: :serial, comment: "Work Detail", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "dayofweek", null: false, comment: "Day of Week"
    t.date "date_from", comment: "Starting Date"
    t.date "date_to", comment: "End Date"
    t.float "hour_from", null: false, comment: "Work from"
    t.float "hour_to", null: false, comment: "Work to"
    t.integer "calendar_id", null: false, comment: "Resource's Calendar"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["dayofweek"], name: "resource_calendar_attendance_dayofweek_index"
    t.index ["hour_from"], name: "resource_calendar_attendance_hour_from_index"
  end

  create_table "resource_calendar_leaves", id: :serial, comment: "Leave Detail", force: :cascade do |t|
    t.string "name", comment: "Reason"
    t.integer "company_id", comment: "Company"
    t.integer "calendar_id", comment: "Working Hours"
    t.datetime "date_from", null: false, comment: "Start Date"
    t.datetime "date_to", null: false, comment: "End Date"
    t.string "tz", comment: "Timezone"
    t.integer "resource_id", comment: "Resource"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "holiday_id", comment: "Leave Request"
  end

  create_table "resource_resource", id: :serial, comment: "Resource Detail", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.boolean "active", comment: "Active"
    t.integer "company_id", comment: "Company"
    t.string "resource_type", null: false, comment: "Resource Type"
    t.integer "user_id", comment: "User"
    t.float "time_efficiency", null: false, comment: "Efficiency Factor"
    t.integer "calendar_id", null: false, comment: "Working Time"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "resource_test", id: :serial, comment: "Test Resource Model", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "resource_id", null: false, comment: "Resource"
    t.integer "company_id", comment: "Company"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["company_id"], name: "resource_test_company_id_index"
    t.index ["resource_id"], name: "resource_test_resource_id_index"
  end

  create_table "return_media", id: :serial, comment: "return.media", force: :cascade do |t|
    t.integer "media_id", comment: "Media"
    t.integer "media_unit_id", null: false, comment: "Media Unit"
    t.date "actual_return_date", null: false, comment: "Actual Return Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "rule_group_rel", id: false, comment: "RELATION BETWEEN ir_rule AND res_groups", force: :cascade do |t|
    t.integer "rule_group_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id"], name: "rule_group_rel_group_id_idx"
    t.index ["rule_group_id", "group_id"], name: "rule_group_rel_rule_group_id_group_id_key", unique: true
    t.index ["rule_group_id"], name: "rule_group_rel_rule_group_id_idx"
  end

  create_table "sale_advance_payment_inv", id: :serial, comment: "Sales Advance Payment Invoice", force: :cascade do |t|
    t.string "advance_payment_method", null: false, comment: "What do you want to invoice?"
    t.integer "product_id", comment: "Down Payment Product"
    t.integer "count", comment: "# of Orders"
    t.decimal "amount", comment: "Down Payment Amount"
    t.integer "deposit_account_id", comment: "Income Account"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "sale_layout_category", id: :serial, comment: "sale.layout_category", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "sequence", null: false, comment: "Sequence"
    t.boolean "subtotal", comment: "Add subtotal"
    t.boolean "pagebreak", comment: "Add pagebreak"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "sale_order", id: :serial, comment: "Quotation", force: :cascade do |t|
    t.string "name", null: false, comment: "Order Reference"
    t.string "origin", comment: "Source Document"
    t.string "client_order_ref", comment: "Customer Reference"
    t.string "access_token", comment: "Security Token"
    t.string "state", comment: "Status"
    t.datetime "date_order", null: false, comment: "Order Date"
    t.date "validity_date", comment: "Expiration Date"
    t.datetime "create_date", comment: "Creation Date"
    t.datetime "confirmation_date", comment: "Confirmation Date"
    t.integer "user_id", comment: "Salesperson"
    t.integer "partner_id", null: false, comment: "Customer"
    t.integer "partner_invoice_id", null: false, comment: "Invoice Address"
    t.integer "partner_shipping_id", null: false, comment: "Delivery Address"
    t.integer "pricelist_id", null: false, comment: "Pricelist"
    t.integer "analytic_account_id", comment: "Analytic Account"
    t.string "invoice_status", comment: "Invoice Status"
    t.text "note", comment: "Terms and conditions"
    t.decimal "amount_untaxed", comment: "Untaxed Amount"
    t.decimal "amount_tax", comment: "Taxes"
    t.decimal "amount_total", comment: "Total"
    t.integer "payment_term_id", comment: "Payment Terms"
    t.integer "fiscal_position_id", comment: "Fiscal Position"
    t.integer "company_id", comment: "Company"
    t.integer "team_id", comment: "Sales Channel"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "campaign_id", comment: "Campaign"
    t.integer "source_id", comment: "Source"
    t.integer "medium_id", comment: "Medium"
    t.integer "opportunity_id", comment: "Opportunity"
    t.integer "payment_tx_id", comment: "Last Transaction"
    t.integer "payment_acquirer_id", comment: "Payment Acquirer"
    t.integer "journal_id", comment: "Payment method"
    t.integer "admission_company_id", comment: "Admission Company"
    t.string "sale_type", comment: "Type"
    t.integer "main_order", comment: "Related Main Order"
    t.string "order_mode", comment: "Order Mode"
    t.float "probability", comment: "Probability"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
    t.index ["confirmation_date"], name: "sale_order_confirmation_date_index"
    t.index ["create_date"], name: "sale_order_create_date_index"
    t.index ["date_order"], name: "sale_order_date_order_index"
    t.index ["name"], name: "sale_order_name_index"
    t.index ["partner_id"], name: "sale_order_partner_id_index"
    t.index ["state"], name: "sale_order_state_index"
    t.index ["user_id"], name: "sale_order_user_id_index"
  end

  create_table "sale_order_line", id: :serial, comment: "Sales Order Line", force: :cascade do |t|
    t.integer "order_id", null: false, comment: "Order Reference"
    t.text "name", null: false, comment: "Description"
    t.integer "sequence", comment: "Sequence"
    t.string "invoice_status", comment: "Invoice Status"
    t.decimal "price_unit", null: false, comment: "Unit Price"
    t.decimal "price_subtotal", comment: "Subtotal"
    t.float "price_tax", comment: "Taxes"
    t.decimal "price_total", comment: "Total"
    t.decimal "price_reduce", comment: "Price Reduce"
    t.decimal "price_reduce_taxinc", comment: "Price Reduce Tax inc"
    t.decimal "price_reduce_taxexcl", comment: "Price Reduce Tax excl"
    t.decimal "discount", comment: "Discount (%)"
    t.integer "product_id", null: false, comment: "Product"
    t.decimal "product_uom_qty", null: false, comment: "Quantity"
    t.integer "product_uom", null: false, comment: "Unit of Measure"
    t.decimal "qty_delivered", comment: "Delivered"
    t.decimal "qty_to_invoice", comment: "To Invoice"
    t.decimal "qty_invoiced", comment: "Invoiced"
    t.integer "salesman_id", comment: "Salesperson"
    t.integer "currency_id", comment: "Currency"
    t.integer "company_id", comment: "Company"
    t.integer "order_partner_id", comment: "Customer"
    t.boolean "is_downpayment", comment: "Is a down payment"
    t.string "state", comment: "Order Status"
    t.float "customer_lead", null: false, comment: "Delivery Lead Time"
    t.decimal "amt_to_invoice", comment: "Amount To Invoice"
    t.decimal "amt_invoiced", comment: "Amount Invoiced"
    t.integer "layout_category_id", comment: "Section"
    t.integer "layout_category_sequence", comment: "Layout Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "student_name", comment: "Student Name"
    t.date "student_birthdate", comment: "Student's Birthday"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.boolean "already_student", comment: "Already Student"
    t.integer "student_id", comment: "Student"
    t.integer "faculty_id", comment: "Faculty"
    t.integer "student_test_id", comment: "Student Test"
    t.string "student_test_state", comment: "Student Test Status"
    t.string "line_mode", comment: "Line Mode"
    t.integer "task_id", comment: "Task"
    t.boolean "is_service", comment: "Is a Service"
    t.index ["order_id"], name: "sale_order_line_order_id_index"
    t.index ["task_id"], name: "sale_order_line_task_id_index"
  end

  create_table "sale_order_line_invoice_rel", id: false, comment: "RELATION BETWEEN account_invoice_line AND sale_order_line", force: :cascade do |t|
    t.integer "invoice_line_id", null: false
    t.integer "order_line_id", null: false
    t.index ["invoice_line_id", "order_line_id"], name: "sale_order_line_invoice_rel_invoice_line_id_order_line_id_key", unique: true
    t.index ["invoice_line_id"], name: "sale_order_line_invoice_rel_invoice_line_id_idx"
    t.index ["order_line_id"], name: "sale_order_line_invoice_rel_order_line_id_idx"
  end

  create_table "sale_order_line_subject_rel", id: false, comment: "RELATION BETWEEN sale_order_line AND op_subject", force: :cascade do |t|
    t.integer "order_line_id", null: false
    t.integer "subject_id", null: false
    t.index ["order_line_id", "subject_id"], name: "sale_order_line_subject_rel_order_line_id_subject_id_key", unique: true
    t.index ["order_line_id"], name: "sale_order_line_subject_rel_order_line_id_idx"
    t.index ["subject_id"], name: "sale_order_line_subject_rel_subject_id_idx"
  end

  create_table "sale_order_tag_rel", id: false, comment: "RELATION BETWEEN sale_order AND crm_lead_tag", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "tag_id", null: false
    t.index ["order_id", "tag_id"], name: "sale_order_tag_rel_order_id_tag_id_key", unique: true
    t.index ["order_id"], name: "sale_order_tag_rel_order_id_idx"
    t.index ["tag_id"], name: "sale_order_tag_rel_tag_id_idx"
  end

  create_table "sc_products", force: :cascade do |t|
    t.text "description"
    t.text "presentation"
    t.text "video"
    t.text "thumbnail"
    t.integer "batch_id"
    t.integer "user_id"
    t.integer "course_id"
    t.integer "student_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "session_change_tutors_id", id: false, comment: "RELATION BETWEEN op_session_change_faculty AND op_faculty", force: :cascade do |t|
    t.integer "change_id", null: false
    t.integer "faculty_id", null: false
    t.index ["change_id", "faculty_id"], name: "session_change_tutors_id_change_id_faculty_id_key", unique: true
    t.index ["change_id"], name: "session_change_tutors_id_change_id_idx"
    t.index ["faculty_id"], name: "session_change_tutors_id_faculty_id_idx"
  end

  create_table "session_confirmation", id: :serial, comment: "Wizard for Multiple Session Confirmation", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "session_fa_rel", id: false, comment: "RELATION BETWEEN op_session AND op_faculty", force: :cascade do |t|
    t.integer "name", null: false
    t.integer "partner_id", null: false
    t.index ["name", "partner_id"], name: "session_fa_rel_name_partner_id_key", unique: true
    t.index ["name"], name: "session_fa_rel_name_idx"
    t.index ["partner_id"], name: "session_fa_rel_partner_id_idx"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "slide_category", id: :serial, comment: "Slides Category", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "channel_id", null: false, comment: "Channel"
    t.integer "sequence", comment: "Sequence"
    t.integer "nbr_presentations", comment: "Number of Presentations"
    t.integer "nbr_documents", comment: "Number of Documents"
    t.integer "nbr_videos", comment: "Number of Videos"
    t.integer "nbr_infographics", comment: "Number of Infographics"
    t.integer "total", comment: "Total"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "slide_channel", id: :serial, comment: "Channel for Slides", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "website_meta_title", comment: "Website meta title"
    t.text "website_meta_description", comment: "Website meta description"
    t.string "website_meta_keywords", comment: "Website meta keywords"
    t.boolean "website_published", comment: "Visible in Website"
    t.string "name", null: false, comment: "Name"
    t.boolean "active", comment: "Active"
    t.text "description", comment: "Description"
    t.integer "sequence", comment: "Sequence"
    t.string "promote_strategy", null: false, comment: "Featuring Policy"
    t.integer "custom_slide_id", comment: "Slide to Promote"
    t.integer "promoted_slide_id", comment: "Featured Slide"
    t.integer "nbr_presentations", comment: "Number of Presentations"
    t.integer "nbr_documents", comment: "Number of Documents"
    t.integer "nbr_videos", comment: "Number of Videos"
    t.integer "nbr_infographics", comment: "Number of Infographics"
    t.integer "total", comment: "Total"
    t.integer "publish_template_id", comment: "Published Template"
    t.integer "share_template_id", comment: "Shared Template"
    t.string "visibility", null: false, comment: "Visibility"
    t.text "access_error_msg", comment: "Error Message"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "slide_embed", id: :serial, comment: "Embedded Slides View Counter", force: :cascade do |t|
    t.integer "slide_id", null: false, comment: "Presentation"
    t.string "url", null: false, comment: "Third Party Website URL"
    t.integer "count_views", comment: "# Views"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["slide_id"], name: "slide_embed_slide_id_index"
  end

  create_table "slide_slide", id: :serial, comment: "Slides", force: :cascade do |t|
    t.datetime "message_last_post", comment: "Last Message Date"
    t.string "website_meta_title", comment: "Website meta title"
    t.text "website_meta_description", comment: "Website meta description"
    t.string "website_meta_keywords", comment: "Website meta keywords"
    t.string "name", null: false, comment: "Title"
    t.boolean "active", comment: "Active"
    t.text "description", comment: "Description"
    t.integer "channel_id", null: false, comment: "Channel"
    t.integer "category_id", comment: "Category"
    t.string "download_security", null: false, comment: "Download Security"
    t.string "slide_type", null: false, comment: "Type"
    t.text "index_content", comment: "Transcript"
    t.string "url", comment: "Document URL"
    t.string "document_id", comment: "Document ID"
    t.string "mime_type", comment: "Mime-type"
    t.datetime "date_published", comment: "Publish Date"
    t.integer "likes", comment: "Likes"
    t.integer "dislikes", comment: "Dislikes"
    t.integer "slide_views", comment: "# of Website Views"
    t.integer "embed_views", comment: "# of Embedded Views"
    t.integer "total_views", comment: "Total # Views"
    t.boolean "website_published", comment: "Visible in Website"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["channel_id", "name"], name: "slide_slide_name_uniq", unique: true
  end

  create_table "slide_tag", id: :serial, comment: "Slide Tag", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["name"], name: "slide_tag_slide_tag_unique", unique: true
  end

  create_table "sms_send_sms", id: :serial, comment: "sms.send_sms", force: :cascade do |t|
    t.string "recipients", null: false, comment: "Recipients"
    t.text "message", null: false, comment: "Message"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "sparse_fields_test", id: :serial, comment: "sparse_fields.test", force: :cascade do |t|
    t.text "data", comment: "Data"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "student_attendance", id: :serial, comment: "student.attendance", force: :cascade do |t|
    t.date "from_date", null: false, comment: "From Date"
    t.date "to_date", null: false, comment: "To Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "student_hall_ticket", id: :serial, comment: "student.hall.ticket", force: :cascade do |t|
    t.integer "exam_session_id", null: false, comment: "Exam Session"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "student_leave", id: :serial, comment: "student.leave", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.date "date", null: false, comment: "Date"
    t.integer "course_id", null: false, comment: "Course"
    t.integer "batch_id", null: false, comment: "Batch"
    t.integer "user_id", comment: "User Create"
    t.string "state", comment: "State"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
  end

  create_table "student_leave_student", id: false, comment: "RELATION BETWEEN student_leave AND op_student", force: :cascade do |t|
    t.integer "student_leave_id", null: false
    t.integer "student_id", null: false
    t.index ["student_id"], name: "student_leave_student_student_id_idx"
    t.index ["student_leave_id", "student_id"], name: "student_leave_student_student_leave_id_student_id_key", unique: true
    t.index ["student_leave_id"], name: "student_leave_student_student_leave_id_idx"
  end

  create_table "student_migrate", id: :serial, comment: "student.migrate", force: :cascade do |t|
    t.date "date", null: false, comment: "Date"
    t.integer "course_from_id", null: false, comment: "From Course"
    t.integer "course_to_id", null: false, comment: "To Course"
    t.integer "batch_id", comment: "To Batch"
    t.boolean "optional_sub", comment: "Optional Subjects"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.datetime "submit_date", comment: "Submit date"
    t.string "state", comment: "Status"
    t.integer "batch_from_id", comment: "From Batch"
  end

  create_table "student_test", id: :serial, comment: "Student test", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "faculty_id", comment: "Faculty"
    t.integer "order_id", comment: "Sale Order"
    t.integer "student_id", comment: "Student"
    t.string "student_name", comment: "Student Name"
    t.boolean "already_student", comment: "Already Student"
    t.integer "course_id", comment: "Course"
    t.string "state", comment: "State"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "product_id", comment: "Product"
    t.integer "batch_id", comment: "Batch"
    t.integer "company_id", comment: "Company"
    t.integer "order_line_id", comment: "Sale Order Line"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.text "reason", comment: "Rejecting Reason"
    t.integer "currency_id", comment: "Currency"
    t.integer "opportunity_id", comment: "Opportunity"
    t.date "student_dob", comment: "Date of Birth"
    t.string "student_school", comment: "School"
    t.date "expect_start_date", comment: "Expected Start Date"
    t.boolean "has_learnt", comment: "Student Has Learnt At School / Other Institute?"
    t.string "learnt_for", comment: "Duration Student Has Learnt"
    t.string "percentage", comment: "Quests completed Percentage in 15 minutes"
    t.string "teacher_support", comment: "Need support from teacher"
    t.string "knowledge", comment: "How well student can acquire concepts of new lessons"
    t.string "additional", comment: "Solving the additional quests"
    t.string "evaluate", comment: "Evaluation"
    t.integer "confirm_course_id", comment: "Confirming Course"
    t.integer "user_id", comment: "Salesperson"
    t.integer "partner_id", comment: "Customer"
    t.integer "survey_id", comment: "Survey"
    t.integer "input_id", comment: "Input"
    t.string "test_type", null: false, comment: "Test Type"
    t.datetime "test_time", comment: "Test Time"
    t.text "test_note", comment: "Test note"
    t.integer "sale_channel_id", comment: "Sales Channel"
  end

  create_table "student_test_wizard", id: :serial, comment: "student.test.wizard", force: :cascade do |t|
    t.text "reason", null: false, comment: "Rejecting Reason"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "subject_compulsory_rel", id: false, comment: "RELATION BETWEEN op_subject_registration AND op_subject", force: :cascade do |t|
    t.integer "register_id", null: false
    t.integer "subject_id", null: false
    t.index ["register_id", "subject_id"], name: "subject_compulsory_rel_register_id_subject_id_key", unique: true
    t.index ["register_id"], name: "subject_compulsory_rel_register_id_idx"
    t.index ["subject_id"], name: "subject_compulsory_rel_subject_id_idx"
  end

  create_table "summary_dept_rel", id: false, comment: "RELATION BETWEEN hr_holidays_summary_dept AND hr_department", force: :cascade do |t|
    t.integer "sum_id", null: false
    t.integer "dept_id", null: false
    t.index ["dept_id"], name: "summary_dept_rel_dept_id_idx"
    t.index ["sum_id", "dept_id"], name: "summary_dept_rel_sum_id_dept_id_key", unique: true
    t.index ["sum_id"], name: "summary_dept_rel_sum_id_idx"
  end

  create_table "summary_emp_rel", id: false, comment: "RELATION BETWEEN hr_holidays_summary_employee AND hr_employee", force: :cascade do |t|
    t.integer "sum_id", null: false
    t.integer "emp_id", null: false
    t.index ["emp_id"], name: "summary_emp_rel_emp_id_idx"
    t.index ["sum_id", "emp_id"], name: "summary_emp_rel_sum_id_emp_id_key", unique: true
    t.index ["sum_id"], name: "summary_emp_rel_sum_id_idx"
  end

  create_table "survey_label", id: :serial, comment: "Survey Label", force: :cascade do |t|
    t.integer "question_id", comment: "Question"
    t.integer "question_id_2", comment: "Question 2"
    t.integer "sequence", comment: "Label Sequence order"
    t.string "value", null: false, comment: "Suggested value"
    t.float "quizz_mark", comment: "Score for this choice"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "survey_mail_compose_message", id: :serial, comment: "Email composition wizard for Survey", force: :cascade do |t|
    t.integer "survey_id", null: false, comment: "Survey"
    t.string "public", null: false, comment: "Share options"
    t.text "multi_email", comment: "List of emails"
    t.date "date_deadline", comment: "Deadline to which the invitation to respond is valid"
    t.string "composition_mode", comment: "Composition mode"
    t.boolean "use_active_domain", comment: "Use active domain"
    t.text "active_domain", comment: "Active domain"
    t.boolean "is_log", comment: "Log an Internal Note"
    t.string "subject", comment: "Subject"
    t.boolean "notify", comment: "Notify followers"
    t.boolean "auto_delete", comment: "Delete Emails"
    t.boolean "auto_delete_message", comment: "Delete Message Copy"
    t.integer "template_id", comment: "Use template"
    t.string "message_type", null: false, comment: "Type"
    t.integer "subtype_id", comment: "Subtype"
    t.integer "mass_mailing_campaign_id", comment: "Mass Mailing Campaign"
    t.integer "mass_mailing_id", comment: "Mass Mailing"
    t.string "mass_mailing_name", comment: "Mass Mailing"
    t.boolean "website_published", comment: "Published"
    t.datetime "date", comment: "Date"
    t.text "body", comment: "Contents"
    t.integer "parent_id", comment: "Parent Message"
    t.string "model", comment: "Related Document Model"
    t.integer "res_id", comment: "Related Document ID"
    t.string "record_name", comment: "Message Record Name"
    t.integer "mail_activity_type_id", comment: "Mail Activity Type"
    t.string "email_from", comment: "From"
    t.integer "author_id", comment: "Author"
    t.boolean "no_auto_thread", comment: "No threading for answers"
    t.string "message_id", comment: "Message-Id"
    t.string "reply_to", comment: "Reply-To"
    t.integer "mail_server_id", comment: "Outgoing mail server"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.float "rating_value", comment: "Rating Value"
    t.index ["author_id"], name: "survey_mail_compose_message_author_id_index"
    t.index ["mail_activity_type_id"], name: "survey_mail_compose_message_mail_activity_type_id_index"
    t.index ["message_id"], name: "survey_mail_compose_message_message_id_index"
    t.index ["model"], name: "survey_mail_compose_message_model_index"
    t.index ["parent_id"], name: "survey_mail_compose_message_parent_id_index"
    t.index ["res_id"], name: "survey_mail_compose_message_res_id_index"
    t.index ["subtype_id"], name: "survey_mail_compose_message_subtype_id_index"
    t.index ["template_id"], name: "survey_mail_compose_message_template_id_index"
  end

  create_table "survey_mail_compose_message_ir_attachments_rel", id: false, comment: "RELATION BETWEEN survey_mail_compose_message AND ir_attachment", force: :cascade do |t|
    t.integer "wizard_id", null: false
    t.integer "attachment_id", null: false
    t.index ["attachment_id"], name: "survey_mail_compose_message_ir_attachments_re_attachment_id_idx"
    t.index ["wizard_id", "attachment_id"], name: "survey_mail_compose_message_ir_atta_wizard_id_attachment_id_key", unique: true
    t.index ["wizard_id"], name: "survey_mail_compose_message_ir_attachments_rel_wizard_id_idx"
  end

  create_table "survey_mail_compose_message_res_partner_rel", id: false, comment: "RELATION BETWEEN survey_mail_compose_message AND res_partner", force: :cascade do |t|
    t.integer "wizard_id", null: false
    t.integer "partner_id", null: false
    t.index ["partner_id"], name: "survey_mail_compose_message_res_partner_rel_partner_id_idx"
    t.index ["wizard_id", "partner_id"], name: "survey_mail_compose_message_res_partne_wizard_id_partner_id_key", unique: true
    t.index ["wizard_id"], name: "survey_mail_compose_message_res_partner_rel_wizard_id_idx"
  end

  create_table "survey_page", id: :serial, comment: "Survey Page", force: :cascade do |t|
    t.string "title", null: false, comment: "Page Title"
    t.integer "survey_id", null: false, comment: "Survey"
    t.integer "sequence", comment: "Page number"
    t.text "description", comment: "Description"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "survey_question", id: :serial, comment: "Survey Question", force: :cascade do |t|
    t.integer "page_id", null: false, comment: "Survey page"
    t.integer "sequence", comment: "Sequence"
    t.string "question", null: false, comment: "Question Name"
    t.text "description", comment: "Description"
    t.string "type", null: false, comment: "Type of Question"
    t.string "matrix_subtype", comment: "Matrix Type"
    t.string "column_nb", comment: "Number of columns"
    t.string "display_mode", comment: "Display Mode"
    t.boolean "comments_allowed", comment: "Show Comments Field"
    t.string "comments_message", comment: "Comment Message"
    t.boolean "comment_count_as_answer", comment: "Comment Field is an Answer Choice"
    t.boolean "validation_required", comment: "Validate entry"
    t.boolean "validation_email", comment: "Input must be an email"
    t.integer "validation_length_min", comment: "Minimum Text Length"
    t.integer "validation_length_max", comment: "Maximum Text Length"
    t.float "validation_min_float_value", comment: "Minimum value"
    t.float "validation_max_float_value", comment: "Maximum value"
    t.date "validation_min_date", comment: "Minimum Date"
    t.date "validation_max_date", comment: "Maximum Date"
    t.string "validation_error_msg", comment: "Validation Error message"
    t.boolean "constr_mandatory", comment: "Mandatory Answer"
    t.string "constr_error_msg", comment: "Error message"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "survey_stage", id: :serial, comment: "Survey Stage", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "sequence", comment: "Sequence"
    t.boolean "closed", comment: "Closed"
    t.boolean "fold", comment: "Folded in kanban view"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "survey_survey", id: :serial, comment: "Survey", force: :cascade do |t|
    t.string "title", null: false, comment: "Title"
    t.integer "stage_id", comment: "Stage"
    t.boolean "auth_required", comment: "Login required"
    t.boolean "users_can_go_back", comment: "Users can go back"
    t.text "description", comment: "Description"
    t.integer "color", comment: "Color Index"
    t.integer "email_template_id", comment: "Email Template"
    t.text "thank_you_message", comment: "Thanks Message"
    t.boolean "quizz_mode", comment: "Quizz Mode"
    t.boolean "active", comment: "Active"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
  end

  create_table "survey_user_input", id: :serial, comment: "Survey User Input", force: :cascade do |t|
    t.integer "survey_id", null: false, comment: "Survey"
    t.datetime "date_create", null: false, comment: "Creation Date"
    t.datetime "deadline", comment: "Deadline"
    t.string "type", null: false, comment: "Answer Type"
    t.string "state", comment: "Status"
    t.boolean "test_entry", comment: "Test Entry"
    t.string "token", null: false, comment: "Identification token"
    t.integer "partner_id", comment: "Partner"
    t.string "email", comment: "E-mail"
    t.integer "last_displayed_page_id", comment: "Last displayed page"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.float "quizz_score", comment: "Score for the quiz"
    t.index ["token"], name: "survey_user_input_unique_token", unique: true
  end

  create_table "survey_user_input_line", id: :serial, comment: "Survey User Input Line", force: :cascade do |t|
    t.integer "user_input_id", null: false, comment: "User Input"
    t.integer "question_id", null: false, comment: "Question"
    t.integer "survey_id", comment: "Survey"
    t.datetime "date_create", null: false, comment: "Create Date"
    t.boolean "skipped", comment: "Skipped"
    t.string "answer_type", comment: "Answer Type"
    t.string "value_text", comment: "Text answer"
    t.float "value_number", comment: "Numerical answer"
    t.date "value_date", comment: "Date answer"
    t.text "value_free_text", comment: "Free Text answer"
    t.integer "value_suggested", comment: "Suggested answer"
    t.integer "value_suggested_row", comment: "Row answer"
    t.float "quizz_mark", comment: "Score given for this choice"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "tax_adjustments_wizard", id: :serial, comment: "Wizard for Tax Adjustments", force: :cascade do |t|
    t.string "reason", null: false, comment: "Justification"
    t.integer "journal_id", null: false, comment: "Journal"
    t.date "date", null: false, comment: "Date"
    t.integer "debit_account_id", null: false, comment: "Debit account"
    t.integer "credit_account_id", null: false, comment: "Credit account"
    t.decimal "amount", null: false, comment: "Amount"
    t.integer "company_currency_id", comment: "Company Currency"
    t.integer "tax_id", null: false, comment: "Adjustment Tax"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "team_favorite_user_rel", id: false, comment: "RELATION BETWEEN crm_team AND res_users", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.index ["team_id", "user_id"], name: "team_favorite_user_rel_team_id_user_id_key", unique: true
    t.index ["team_id"], name: "team_favorite_user_rel_team_id_idx"
    t.index ["user_id"], name: "team_favorite_user_rel_user_id_idx"
  end

  create_table "teky_qldc", id: :serial, comment: "Quản lý đổi ca", force: :cascade do |t|
    t.integer "employee_id", comment: "Employee"
    t.datetime "create_date", comment: "Create Date"
    t.string "select_day", comment: "Select Day"
    t.string "state", comment: "State"
    t.string "di_muon", comment: "Đi muộn"
    t.string "ve_som", comment: "Về sớm"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.integer "user_id", comment: "User"
    t.integer "parent_id", comment: "Manager"
    t.integer "department_id", comment: "Department"
    t.integer "company_id", comment: "Company"
    t.date "check_date", comment: "Check date"
    t.datetime "work_from", comment: "Work From"
    t.datetime "work_to", comment: "Work To"
    t.date "activity_date_deadline", comment: "Next Activity Deadline"
    t.datetime "message_last_post", comment: "Last Message Date"
    t.datetime "activity_datetime_deadline", comment: "Next Activity Datetime Deadline"
  end

  create_table "test_ir_rel", id: false, comment: "RELATION BETWEEN student_test AND ir_attachment", force: :cascade do |t|
    t.integer "test_id", null: false
    t.integer "attachment_id", null: false
    t.index ["attachment_id"], name: "test_ir_rel_attachment_id_idx"
    t.index ["test_id", "attachment_id"], name: "test_ir_rel_test_id_attachment_id_key", unique: true
    t.index ["test_id"], name: "test_ir_rel_test_id_idx"
  end

  create_table "time_table_report", id: :serial, comment: "Generate Time Table Report", force: :cascade do |t|
    t.string "state", null: false, comment: "Select"
    t.integer "course_id", comment: "Course"
    t.integer "batch_id", comment: "Batch"
    t.integer "faculty_id", comment: "Faculty"
    t.date "start_date", null: false, comment: "Start Date"
    t.date "end_date", null: false, comment: "End Date"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "timetable_line_faculty_rel", id: false, comment: "RELATION BETWEEN gen_time_table_line AND op_faculty", force: :cascade do |t|
    t.integer "timetable_line_id", null: false
    t.integer "faculty_id", null: false
    t.index ["faculty_id"], name: "timetable_line_faculty_rel_faculty_id_idx"
    t.index ["timetable_line_id", "faculty_id"], name: "timetable_line_faculty_rel_timetable_line_id_faculty_id_key", unique: true
    t.index ["timetable_line_id"], name: "timetable_line_faculty_rel_timetable_line_id_idx"
  end

  create_table "user_answers", force: :cascade do |t|
    t.bigint "user_question_id"
    t.bigint "question_choice_id"
    t.text "answer_content"
    t.string "state"
    t.datetime "answer_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "batch_id"
    t.bigint "faculty_id"
    t.index ["faculty_id"], name: "index_user_answers_on_faculty_id"
    t.index ["question_choice_id"], name: "index_user_answers_on_question_choice_id"
    t.index ["user_question_id"], name: "index_user_answers_on_user_question_id"
  end

  create_table "user_questions", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "question_id"
    t.bigint "op_batch_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["op_batch_id"], name: "index_user_questions_on_op_batch_id"
    t.index ["question_id"], name: "index_user_questions_on_question_id"
    t.index ["student_id"], name: "index_user_questions_on_student_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "account_role"
    t.boolean "status"
    t.integer "parent_account_id"
    t.integer "parent_id"
    t.integer "student_id"
    t.integer "star"
    t.integer "coin"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "faculty_id"
    t.bigint "avatar_id"
    t.index ["account_role"], name: "index_users_on_account_role"
    t.index ["avatar_id"], name: "index_users_on_avatar_id"
  end

  create_table "utm_campaign", id: :serial, comment: "Campaign", force: :cascade do |t|
    t.string "name", null: false, comment: "Campaign Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "utm_medium", id: :serial, comment: "Channels", force: :cascade do |t|
    t.string "name", null: false, comment: "Channel Name"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "utm_source", id: :serial, comment: "Source", force: :cascade do |t|
    t.string "name", null: false, comment: "Source Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "validate_account_move", id: :serial, comment: "Validate Account Move", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "web_editor_converter_test", id: :serial, comment: "web_editor.converter.test", force: :cascade do |t|
    t.string "char", comment: "Char"
    t.integer "integer", comment: "Integer"
    t.float "float", comment: "Float"
    t.decimal "numeric", comment: "Numeric"
    t.integer "many2one", comment: "Many2One"
    t.binary "binary", comment: "Binary"
    t.date "date", comment: "Date"
    t.datetime "datetime", comment: "Datetime"
    t.integer "selection", comment: "Selection"
    t.string "selection_str", comment: "Lorsqu'un pancake prend l'avion à destination de Toronto et qu'il fait une escale technique à St Claude, on dit:"
    t.text "html", comment: "Html"
    t.text "text", comment: "Text"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "web_editor_converter_test_sub", id: :serial, comment: "web_editor.converter.test.sub", force: :cascade do |t|
    t.string "name", comment: "Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "web_planner", id: :serial, comment: "Planner", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.integer "menu_id", null: false, comment: "Menu"
    t.integer "view_id", null: false, comment: "Template"
    t.text "tooltip_planner", comment: "Planner Tooltips"
    t.string "planner_application", null: false, comment: "Planner Application"
    t.boolean "active", comment: "Active"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "web_tour_tour", id: :serial, comment: "Tours", force: :cascade do |t|
    t.string "name", null: false, comment: "Tour name"
    t.integer "user_id", comment: "Consumed by"
  end

  create_table "website", id: :serial, comment: "Website", force: :cascade do |t|
    t.string "name", comment: "Website Name"
    t.string "domain", comment: "Website Domain"
    t.integer "company_id", comment: "Company"
    t.integer "default_lang_id", null: false, comment: "Default Language"
    t.string "default_lang_code", comment: "Default language code"
    t.boolean "auto_redirect_lang", comment: "Autoredirect Language"
    t.string "google_analytics_key", comment: "Google Analytics Key"
    t.string "google_management_client_id", comment: "Google Client ID"
    t.string "google_management_client_secret", comment: "Google Client Secret"
    t.integer "user_id", null: false, comment: "Public User"
    t.boolean "cdn_activated", comment: "Activate CDN for assets"
    t.string "cdn_url", comment: "CDN Base URL"
    t.text "cdn_filters", comment: "CDN Filters"
    t.integer "homepage_id", comment: "Homepage"
    t.binary "favicon", comment: "Website Favicon"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.boolean "website_form_enable_metadata", comment: "Write metadata"
    t.integer "crm_default_team_id", comment: "Default Sales Channels"
    t.integer "crm_default_user_id", comment: "Default Salesperson"
    t.integer "channel_id", comment: "Website Live Chat Channel"
  end

  create_table "website_lang_rel", id: false, comment: "RELATION BETWEEN website AND res_lang", force: :cascade do |t|
    t.integer "website_id", null: false
    t.integer "lang_id", null: false
    t.index ["lang_id"], name: "website_lang_rel_lang_id_idx"
    t.index ["website_id", "lang_id"], name: "website_lang_rel_website_id_lang_id_key", unique: true
    t.index ["website_id"], name: "website_lang_rel_website_id_idx"
  end

  create_table "website_menu", id: :serial, comment: "Website Menu", force: :cascade do |t|
    t.integer "parent_left"
    t.integer "parent_right"
    t.string "name", null: false, comment: "Menu"
    t.string "url", comment: "Url"
    t.integer "page_id", comment: "Related Page"
    t.boolean "new_window", comment: "New Window"
    t.integer "sequence", comment: "Sequence"
    t.integer "website_id", comment: "Website"
    t.integer "parent_id", comment: "Parent Menu"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.index ["parent_id"], name: "website_menu_parent_id_index"
    t.index ["parent_left"], name: "website_menu_parent_left_index"
    t.index ["parent_right"], name: "website_menu_parent_right_index"
  end

  create_table "website_page", id: :serial, comment: "Page", force: :cascade do |t|
    t.string "url", comment: "Page URL"
    t.integer "view_id", null: false, comment: "View"
    t.boolean "website_indexed", comment: "Page Indexed"
    t.datetime "date_publish", comment: "Publishing Date"
    t.boolean "website_published", comment: "Visible in Website"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "website_redirect", id: :serial, comment: "Website Redirect", force: :cascade do |t|
    t.string "type", comment: "Redirection Type"
    t.string "url_from", comment: "Redirect From"
    t.string "url_to", comment: "Redirect To"
    t.integer "website_id", comment: "Website"
    t.boolean "active", comment: "Active"
    t.integer "sequence", comment: "Sequence"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "website_website_page_rel", id: false, comment: "RELATION BETWEEN website_page AND website", force: :cascade do |t|
    t.integer "website_page_id", null: false
    t.integer "website_id", null: false
    t.index ["website_id"], name: "website_website_page_rel_website_id_idx"
    t.index ["website_page_id", "website_id"], name: "website_website_page_rel_website_page_id_website_id_key", unique: true
    t.index ["website_page_id"], name: "website_website_page_rel_website_page_id_idx"
  end

  create_table "wizard_document_page_history_show_diff", id: :serial, comment: "wizard.document.page.history.show_diff", force: :cascade do |t|
    t.text "diff", comment: "Diff"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "wizard_ir_model_menu_create", id: :serial, comment: "wizard.ir.model.menu.create", force: :cascade do |t|
    t.integer "menu_id", null: false, comment: "Parent Menu"
    t.string "name", null: false, comment: "Menu Name"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "wizard_merge_faculty", id: :serial, comment: "Merge for selected Faculty(s)", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "wizard_multi_charts_accounts", id: :serial, comment: "wizard.multi.charts.accounts", force: :cascade do |t|
    t.integer "company_id", null: false, comment: "Company"
    t.integer "currency_id", null: false, comment: "Currency"
    t.boolean "only_one_chart_template", comment: "Only One Chart Template Available"
    t.integer "chart_template_id", null: false, comment: "Chart Template"
    t.string "bank_account_code_prefix", comment: "Bank Accounts Prefix"
    t.string "cash_account_code_prefix", comment: "Cash Accounts Prefix"
    t.integer "code_digits", null: false, comment: "# of Digits"
    t.integer "sale_tax_id", comment: "Default Sales Tax"
    t.integer "purchase_tax_id", comment: "Default Purchase Tax"
    t.float "sale_tax_rate", comment: "Sales Tax(%)"
    t.integer "transfer_account_id", null: false, comment: "Transfer Account"
    t.float "purchase_tax_rate", comment: "Purchase Tax(%)"
    t.boolean "complete_tax_set", comment: "Complete Set of Taxes"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "wizard_op_faculty", id: :serial, comment: "Create User for selected Faculty(s)", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "wizard_op_faculty_employee", id: :serial, comment: "Create Employee and User of Faculty", force: :cascade do |t|
    t.boolean "user_boolean", comment: "Want to create user too ?"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "wizard_op_student", id: :serial, comment: "Create User for selected Student(s)", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "work_hours", id: :serial, comment: "Working hours", force: :cascade do |t|
    t.integer "employee_id", comment: "Employee"
    t.date "create_date", comment: "Create Date"
    t.integer "create_uid", comment: "Created by"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "x_lave", id: :serial, comment: "Lave", force: :cascade do |t|
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
    t.string "x_name", comment: "Name"
  end

  add_foreign_key "Tutors", "op_faculty", name: "Tutors_op_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "Tutors", "op_session", name: "Tutors_op_session_id_fkey", on_delete: :cascade
  add_foreign_key "account_account", "account_account_type", column: "user_type_id", name: "account_account_user_type_id_fkey", on_delete: :nullify
  add_foreign_key "account_account", "account_group", column: "group_id", name: "account_account_group_id_fkey", on_delete: :nullify
  add_foreign_key "account_account", "res_company", column: "company_id", name: "account_account_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_account", "res_currency", column: "currency_id", name: "account_account_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_account", "res_users", column: "create_uid", name: "account_account_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_account", "res_users", column: "write_uid", name: "account_account_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_account_account_tag", "account_account", name: "account_account_account_tag_account_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_account_tag", "account_account_tag", name: "account_account_account_tag_account_account_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_financial_report", "account_account", column: "account_id", name: "account_account_financial_report_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_financial_report", "account_financial_report", column: "report_line_id", name: "account_account_financial_report_report_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_financial_report_type", "account_account_type", column: "account_type_id", name: "account_account_financial_report_type_account_type_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_financial_report_type", "account_financial_report", column: "report_id", name: "account_account_financial_report_type_report_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_tag", "res_users", column: "create_uid", name: "account_account_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_account_tag", "res_users", column: "write_uid", name: "account_account_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_account_tag_account_tax_template_rel", "account_account_tag", name: "account_account_tag_account_tax_tem_account_account_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_tag_account_tax_template_rel", "account_tax_template", name: "account_account_tag_account_tax_te_account_tax_template_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_tax_default_rel", "account_account", column: "account_id", name: "account_account_tax_default_rel_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_tax_default_rel", "account_tax", column: "tax_id", name: "account_account_tax_default_rel_tax_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_template", "account_account_type", column: "user_type_id", name: "account_account_template_user_type_id_fkey", on_delete: :nullify
  add_foreign_key "account_account_template", "account_chart_template", column: "chart_template_id", name: "account_account_template_chart_template_id_fkey", on_delete: :nullify
  add_foreign_key "account_account_template", "account_group", column: "group_id", name: "account_account_template_group_id_fkey", on_delete: :nullify
  add_foreign_key "account_account_template", "res_currency", column: "currency_id", name: "account_account_template_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_account_template", "res_users", column: "create_uid", name: "account_account_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_account_template", "res_users", column: "write_uid", name: "account_account_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_account_template_account_tag", "account_account_tag", name: "account_account_template_account_ta_account_account_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_template_account_tag", "account_account_template", name: "account_account_template_accou_account_account_template_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_template_tax_rel", "account_account_template", column: "account_id", name: "account_account_template_tax_rel_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_template_tax_rel", "account_tax_template", column: "tax_id", name: "account_account_template_tax_rel_tax_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_type", "res_users", column: "create_uid", name: "account_account_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_account_type", "res_users", column: "write_uid", name: "account_account_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_account_type_rel", "account_account", column: "account_id", name: "account_account_type_rel_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_account_type_rel", "account_journal", column: "journal_id", name: "account_account_type_rel_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_aged_trial_balance", "res_company", column: "company_id", name: "account_aged_trial_balance_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_aged_trial_balance", "res_users", column: "create_uid", name: "account_aged_trial_balance_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_aged_trial_balance", "res_users", column: "write_uid", name: "account_aged_trial_balance_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_aged_trial_balance_account_journal_rel", "account_aged_trial_balance", name: "account_aged_trial_balance_ac_account_aged_trial_balance_i_fkey", on_delete: :cascade
  add_foreign_key "account_aged_trial_balance_account_journal_rel", "account_journal", name: "account_aged_trial_balance_account_jour_account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_account", "res_company", column: "company_id", name: "account_analytic_account_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_account", "res_partner", column: "partner_id", name: "account_analytic_account_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_account", "res_users", column: "create_uid", name: "account_analytic_account_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_account", "res_users", column: "write_uid", name: "account_analytic_account_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_account_tag_rel", "account_analytic_account", column: "account_id", name: "account_analytic_account_tag_rel_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_account_tag_rel", "account_analytic_tag", column: "tag_id", name: "account_analytic_account_tag_rel_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_line", "account_account", column: "general_account_id", name: "account_analytic_line_general_account_id_fkey", on_delete: :restrict
  add_foreign_key "account_analytic_line", "account_analytic_account", column: "account_id", name: "account_analytic_line_account_id_fkey", on_delete: :restrict
  add_foreign_key "account_analytic_line", "account_invoice", column: "timesheet_invoice_id", name: "account_analytic_line_timesheet_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "account_move_line", column: "move_id", name: "account_analytic_line_move_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_line", "hr_department", column: "department_id", name: "account_analytic_line_department_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "hr_employee", column: "employee_id", name: "account_analytic_line_employee_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "hr_holidays", column: "holiday_id", name: "account_analytic_line_holiday_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "product_product", column: "product_id", name: "account_analytic_line_product_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "product_uom", name: "account_analytic_line_product_uom_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "project_project", column: "project_id", name: "account_analytic_line_project_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "project_task", column: "task_id", name: "account_analytic_line_task_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "res_company", column: "company_id", name: "account_analytic_line_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "res_currency", column: "currency_id", name: "account_analytic_line_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "res_partner", column: "partner_id", name: "account_analytic_line_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "res_users", column: "create_uid", name: "account_analytic_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "res_users", column: "user_id", name: "account_analytic_line_user_id_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "res_users", column: "write_uid", name: "account_analytic_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line", "sale_order_line", column: "so_line", name: "account_analytic_line_so_line_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_line_tag_rel", "account_analytic_line", column: "line_id", name: "account_analytic_line_tag_rel_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_line_tag_rel", "account_analytic_tag", column: "tag_id", name: "account_analytic_line_tag_rel_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_tag", "res_users", column: "create_uid", name: "account_analytic_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_tag", "res_users", column: "write_uid", name: "account_analytic_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_analytic_tag_account_invoice_line_rel", "account_analytic_tag", name: "account_analytic_tag_account_invoi_account_analytic_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_tag_account_invoice_line_rel", "account_invoice_line", name: "account_analytic_tag_account_invoi_account_invoice_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_tag_account_move_line_rel", "account_analytic_tag", name: "account_analytic_tag_account_move__account_analytic_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_tag_account_move_line_rel", "account_move_line", name: "account_analytic_tag_account_move_lin_account_move_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_tag_sale_order_line_rel", "account_analytic_tag", name: "account_analytic_tag_sale_order_li_account_analytic_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_analytic_tag_sale_order_line_rel", "sale_order_line", name: "account_analytic_tag_sale_order_line_re_sale_order_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_asset_asset", "account_asset_category", column: "category_id", name: "account_asset_asset_category_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_asset", "account_invoice", column: "invoice_id", name: "account_asset_asset_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_asset", "res_company", column: "company_id", name: "account_asset_asset_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_asset", "res_currency", column: "currency_id", name: "account_asset_asset_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_asset", "res_partner", column: "partner_id", name: "account_asset_asset_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_asset", "res_users", column: "create_uid", name: "account_asset_asset_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_asset_asset", "res_users", column: "write_uid", name: "account_asset_asset_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_asset_category", "account_account", column: "account_asset_id", name: "account_asset_category_account_asset_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_category", "account_account", column: "account_depreciation_expense_id", name: "account_asset_category_account_depreciation_expense_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_category", "account_account", column: "account_depreciation_id", name: "account_asset_category_account_depreciation_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_category", "account_analytic_account", column: "account_analytic_id", name: "account_asset_category_account_analytic_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_category", "account_journal", column: "journal_id", name: "account_asset_category_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_category", "res_company", column: "company_id", name: "account_asset_category_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_category", "res_users", column: "create_uid", name: "account_asset_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_asset_category", "res_users", column: "write_uid", name: "account_asset_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_asset_depreciation_line", "account_asset_asset", column: "asset_id", name: "account_asset_depreciation_line_asset_id_fkey", on_delete: :cascade
  add_foreign_key "account_asset_depreciation_line", "account_move", column: "move_id", name: "account_asset_depreciation_line_move_id_fkey", on_delete: :nullify
  add_foreign_key "account_asset_depreciation_line", "res_users", column: "create_uid", name: "account_asset_depreciation_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_asset_depreciation_line", "res_users", column: "write_uid", name: "account_asset_depreciation_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_balance_report", "res_company", column: "company_id", name: "account_balance_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_balance_report", "res_users", column: "create_uid", name: "account_balance_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_balance_report", "res_users", column: "write_uid", name: "account_balance_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_balance_report_journal_rel", "account_balance_report", column: "account_id", name: "account_balance_report_journal_rel_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_balance_report_journal_rel", "account_journal", column: "journal_id", name: "account_balance_report_journal_rel_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_bank_accounts_wizard", "res_currency", column: "currency_id", name: "account_bank_accounts_wizard_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_accounts_wizard", "res_users", column: "create_uid", name: "account_bank_accounts_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_accounts_wizard", "res_users", column: "write_uid", name: "account_bank_accounts_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_accounts_wizard", "wizard_multi_charts_accounts", column: "bank_account_id", name: "account_bank_accounts_wizard_bank_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_bank_statement", "account_bank_statement_cashbox", column: "cashbox_end_id", name: "account_bank_statement_cashbox_end_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement", "account_bank_statement_cashbox", column: "cashbox_start_id", name: "account_bank_statement_cashbox_start_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement", "account_journal", column: "journal_id", name: "account_bank_statement_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement", "pos_session", name: "account_bank_statement_pos_session_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement", "res_company", column: "company_id", name: "account_bank_statement_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement", "res_users", column: "create_uid", name: "account_bank_statement_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement", "res_users", column: "user_id", name: "account_bank_statement_user_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement", "res_users", column: "write_uid", name: "account_bank_statement_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_cashbox", "res_users", column: "create_uid", name: "account_bank_statement_cashbox_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_cashbox", "res_users", column: "write_uid", name: "account_bank_statement_cashbox_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_closebalance", "res_users", column: "create_uid", name: "account_bank_statement_closebalance_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_closebalance", "res_users", column: "write_uid", name: "account_bank_statement_closebalance_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_import", "res_users", column: "create_uid", name: "account_bank_statement_import_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_import", "res_users", column: "write_uid", name: "account_bank_statement_import_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_import_journal_creation", "account_journal", column: "journal_id", name: "account_bank_statement_import_journal_creation_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_bank_statement_import_journal_creation", "res_users", column: "create_uid", name: "account_bank_statement_import_journal_creation_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_import_journal_creation", "res_users", column: "write_uid", name: "account_bank_statement_import_journal_creation_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_line", "account_account", column: "account_id", name: "account_bank_statement_line_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_line", "account_bank_statement", column: "statement_id", name: "account_bank_statement_line_statement_id_fkey", on_delete: :cascade
  add_foreign_key "account_bank_statement_line", "account_journal", column: "journal_id", name: "account_bank_statement_line_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_line", "pos_order", column: "pos_statement_id", name: "account_bank_statement_line_pos_statement_id_fkey", on_delete: :cascade
  add_foreign_key "account_bank_statement_line", "res_company", column: "company_id", name: "account_bank_statement_line_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_line", "res_currency", column: "currency_id", name: "account_bank_statement_line_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_line", "res_partner", column: "partner_id", name: "account_bank_statement_line_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_line", "res_partner_bank", column: "bank_account_id", name: "account_bank_statement_line_bank_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_line", "res_users", column: "create_uid", name: "account_bank_statement_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_bank_statement_line", "res_users", column: "write_uid", name: "account_bank_statement_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_cash_rounding", "account_account", column: "account_id", name: "account_cash_rounding_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_cash_rounding", "res_users", column: "create_uid", name: "account_cash_rounding_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_cash_rounding", "res_users", column: "write_uid", name: "account_cash_rounding_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_cashbox_line", "account_bank_statement_cashbox", column: "cashbox_id", name: "account_cashbox_line_cashbox_id_fkey", on_delete: :nullify
  add_foreign_key "account_cashbox_line", "pos_config", column: "default_pos_id", name: "account_cashbox_line_default_pos_id_fkey", on_delete: :nullify
  add_foreign_key "account_cashbox_line", "res_users", column: "create_uid", name: "account_cashbox_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_cashbox_line", "res_users", column: "write_uid", name: "account_cashbox_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "expense_currency_exchange_account_id", name: "account_chart_template_expense_currency_exchange_account_i_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "income_currency_exchange_account_id", name: "account_chart_template_income_currency_exchange_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_account_expense_categ_id", name: "account_chart_template_property_account_expense_categ_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_account_expense_id", name: "account_chart_template_property_account_expense_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_account_income_categ_id", name: "account_chart_template_property_account_income_categ_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_account_income_id", name: "account_chart_template_property_account_income_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_account_payable_id", name: "account_chart_template_property_account_payable_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_account_receivable_id", name: "account_chart_template_property_account_receivable_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_stock_account_input_categ_id", name: "account_chart_template_property_stock_account_input_categ__fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_stock_account_output_categ_id", name: "account_chart_template_property_stock_account_output_categ_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "property_stock_valuation_account_id", name: "account_chart_template_property_stock_valuation_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_account_template", column: "transfer_account_id", name: "account_chart_template_transfer_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "account_chart_template", column: "parent_id", name: "account_chart_template_parent_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "res_company", column: "company_id", name: "account_chart_template_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "res_currency", column: "currency_id", name: "account_chart_template_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "res_users", column: "create_uid", name: "account_chart_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_chart_template", "res_users", column: "write_uid", name: "account_chart_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_account_report", "res_company", column: "company_id", name: "account_common_account_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_common_account_report", "res_users", column: "create_uid", name: "account_common_account_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_account_report", "res_users", column: "write_uid", name: "account_common_account_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_account_report_account_journal_rel", "account_common_account_report", name: "account_common_account_report_account_common_account_repor_fkey", on_delete: :cascade
  add_foreign_key "account_common_account_report_account_journal_rel", "account_journal", name: "account_common_account_report_account_j_account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_common_journal_report", "res_company", column: "company_id", name: "account_common_journal_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_common_journal_report", "res_users", column: "create_uid", name: "account_common_journal_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_journal_report", "res_users", column: "write_uid", name: "account_common_journal_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_journal_report_account_journal_rel", "account_common_journal_report", name: "account_common_journal_report_account_common_journal_repor_fkey", on_delete: :cascade
  add_foreign_key "account_common_journal_report_account_journal_rel", "account_journal", name: "account_common_journal_report_account_j_account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_common_partner_report", "res_company", column: "company_id", name: "account_common_partner_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_common_partner_report", "res_users", column: "create_uid", name: "account_common_partner_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_partner_report", "res_users", column: "write_uid", name: "account_common_partner_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_partner_report_account_journal_rel", "account_common_partner_report", name: "account_common_partner_report_account_common_partner_repor_fkey", on_delete: :cascade
  add_foreign_key "account_common_partner_report_account_journal_rel", "account_journal", name: "account_common_partner_report_account_j_account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_common_report", "res_company", column: "company_id", name: "account_common_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_common_report", "res_users", column: "create_uid", name: "account_common_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_report", "res_users", column: "write_uid", name: "account_common_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_common_report_account_journal_rel", "account_common_report", name: "account_common_report_account_jou_account_common_report_id_fkey", on_delete: :cascade
  add_foreign_key "account_common_report_account_journal_rel", "account_journal", name: "account_common_report_account_journal_r_account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_financial_report", "account_financial_report", column: "account_report_id", name: "account_financial_report_account_report_id_fkey", on_delete: :nullify
  add_foreign_key "account_financial_report", "account_financial_report", column: "parent_id", name: "account_financial_report_parent_id_fkey", on_delete: :nullify
  add_foreign_key "account_financial_report", "res_users", column: "create_uid", name: "account_financial_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_financial_report", "res_users", column: "write_uid", name: "account_financial_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_financial_year_op", "res_company", column: "company_id", name: "account_financial_year_op_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_financial_year_op", "res_users", column: "create_uid", name: "account_financial_year_op_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_financial_year_op", "res_users", column: "write_uid", name: "account_financial_year_op_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position", "res_company", column: "company_id", name: "account_fiscal_position_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position", "res_country", column: "country_id", name: "account_fiscal_position_country_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position", "res_country_group", column: "country_group_id", name: "account_fiscal_position_country_group_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position", "res_users", column: "create_uid", name: "account_fiscal_position_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position", "res_users", column: "write_uid", name: "account_fiscal_position_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_account", "account_account", column: "account_dest_id", name: "account_fiscal_position_account_account_dest_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_account", "account_account", column: "account_src_id", name: "account_fiscal_position_account_account_src_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_account", "account_fiscal_position", column: "position_id", name: "account_fiscal_position_account_position_id_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_account", "res_users", column: "create_uid", name: "account_fiscal_position_account_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_account", "res_users", column: "write_uid", name: "account_fiscal_position_account_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_account_template", "account_account_template", column: "account_dest_id", name: "account_fiscal_position_account_template_account_dest_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_account_template", "account_account_template", column: "account_src_id", name: "account_fiscal_position_account_template_account_src_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_account_template", "account_fiscal_position_template", column: "position_id", name: "account_fiscal_position_account_template_position_id_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_account_template", "res_users", column: "create_uid", name: "account_fiscal_position_account_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_account_template", "res_users", column: "write_uid", name: "account_fiscal_position_account_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_pos_config_rel", "account_fiscal_position", name: "account_fiscal_position_pos_con_account_fiscal_position_id_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_pos_config_rel", "pos_config", name: "account_fiscal_position_pos_config_rel_pos_config_id_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_res_country_state_rel", "account_fiscal_position", name: "account_fiscal_position_res_cou_account_fiscal_position_id_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_res_country_state_rel", "res_country_state", name: "account_fiscal_position_res_country_s_res_country_state_id_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_tax", "account_fiscal_position", column: "position_id", name: "account_fiscal_position_tax_position_id_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_tax", "account_tax", column: "tax_dest_id", name: "account_fiscal_position_tax_tax_dest_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_tax", "account_tax", column: "tax_src_id", name: "account_fiscal_position_tax_tax_src_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_tax", "res_users", column: "create_uid", name: "account_fiscal_position_tax_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_tax", "res_users", column: "write_uid", name: "account_fiscal_position_tax_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_tax_template", "account_fiscal_position_template", column: "position_id", name: "account_fiscal_position_tax_template_position_id_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_tax_template", "account_tax_template", column: "tax_dest_id", name: "account_fiscal_position_tax_template_tax_dest_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_tax_template", "account_tax_template", column: "tax_src_id", name: "account_fiscal_position_tax_template_tax_src_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_tax_template", "res_users", column: "create_uid", name: "account_fiscal_position_tax_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_tax_template", "res_users", column: "write_uid", name: "account_fiscal_position_tax_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_template", "account_chart_template", column: "chart_template_id", name: "account_fiscal_position_template_chart_template_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_template", "res_country", column: "country_id", name: "account_fiscal_position_template_country_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_template", "res_country_group", column: "country_group_id", name: "account_fiscal_position_template_country_group_id_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_template", "res_users", column: "create_uid", name: "account_fiscal_position_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_template", "res_users", column: "write_uid", name: "account_fiscal_position_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_fiscal_position_template_res_country_state_rel", "account_fiscal_position_template", name: "account_fiscal_position_templ_account_fiscal_position_temp_fkey", on_delete: :cascade
  add_foreign_key "account_fiscal_position_template_res_country_state_rel", "res_country_state", name: "account_fiscal_position_template_res__res_country_state_id_fkey", on_delete: :cascade
  add_foreign_key "account_full_reconcile", "account_move", column: "exchange_move_id", name: "account_full_reconcile_exchange_move_id_fkey", on_delete: :nullify
  add_foreign_key "account_full_reconcile", "res_users", column: "create_uid", name: "account_full_reconcile_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_full_reconcile", "res_users", column: "write_uid", name: "account_full_reconcile_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_group", "account_group", column: "parent_id", name: "account_group_parent_id_fkey", on_delete: :cascade
  add_foreign_key "account_group", "res_users", column: "create_uid", name: "account_group_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_group", "res_users", column: "write_uid", name: "account_group_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "account_account", column: "account_id", name: "account_invoice_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "account_cash_rounding", column: "cash_rounding_id", name: "account_invoice_cash_rounding_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "account_fiscal_position", column: "fiscal_position_id", name: "account_invoice_fiscal_position_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "account_invoice", column: "refund_invoice_id", name: "account_invoice_refund_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "account_journal", column: "journal_id", name: "account_invoice_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "account_move", column: "move_id", name: "account_invoice_move_id_fkey", on_delete: :restrict
  add_foreign_key "account_invoice", "account_payment_term", column: "payment_term_id", name: "account_invoice_payment_term_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "crm_team", column: "team_id", name: "account_invoice_team_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "payment_acquirer", name: "account_invoice_payment_acquirer_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "payment_transaction", column: "payment_tx_id", name: "account_invoice_payment_tx_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_company", column: "company_id", name: "account_invoice_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_currency", column: "currency_id", name: "account_invoice_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_partner", column: "commercial_partner_id", name: "account_invoice_commercial_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_partner", column: "partner_id", name: "account_invoice_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_partner", column: "partner_shipping_id", name: "account_invoice_partner_shipping_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_partner_bank", column: "partner_bank_id", name: "account_invoice_partner_bank_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_users", column: "create_uid", name: "account_invoice_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_users", column: "user_id", name: "account_invoice_user_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "res_users", column: "write_uid", name: "account_invoice_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "utm_campaign", column: "campaign_id", name: "account_invoice_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "utm_medium", column: "medium_id", name: "account_invoice_medium_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice", "utm_source", column: "source_id", name: "account_invoice_source_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_account_move_line_rel", "account_invoice", name: "account_invoice_account_move_line_rel_account_invoice_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_account_move_line_rel", "account_move_line", name: "account_invoice_account_move_line_rel_account_move_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_account_register_payments_rel", "account_invoice", name: "account_invoice_account_register_paymen_account_invoice_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_account_register_payments_rel", "account_register_payments", column: "account_register_payments_id", name: "account_invoice_account_regis_account_register_payments_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_confirm", "res_users", column: "create_uid", name: "account_invoice_confirm_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_confirm", "res_users", column: "write_uid", name: "account_invoice_confirm_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "account_account", column: "account_id", name: "account_invoice_line_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "account_analytic_account", column: "account_analytic_id", name: "account_invoice_line_account_analytic_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "account_asset_category", column: "asset_category_id", name: "account_invoice_line_asset_category_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "account_invoice", column: "invoice_id", name: "account_invoice_line_invoice_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_line", "product_product", column: "product_id", name: "account_invoice_line_product_id_fkey", on_delete: :restrict
  add_foreign_key "account_invoice_line", "product_uom", column: "uom_id", name: "account_invoice_line_uom_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "res_company", column: "company_id", name: "account_invoice_line_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "res_currency", column: "currency_id", name: "account_invoice_line_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "res_partner", column: "partner_id", name: "account_invoice_line_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "res_users", column: "create_uid", name: "account_invoice_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "res_users", column: "write_uid", name: "account_invoice_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line", "sale_layout_category", column: "layout_category_id", name: "account_invoice_line_layout_category_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_line_tax", "account_invoice_line", column: "invoice_line_id", name: "account_invoice_line_tax_invoice_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_line_tax", "account_tax", column: "tax_id", name: "account_invoice_line_tax_tax_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_payment_rel", "account_invoice", column: "invoice_id", name: "account_invoice_payment_rel_invoice_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_payment_rel", "account_payment", column: "payment_id", name: "account_invoice_payment_rel_payment_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_refund", "res_users", column: "create_uid", name: "account_invoice_refund_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_refund", "res_users", column: "write_uid", name: "account_invoice_refund_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_tax", "account_account", column: "account_id", name: "account_invoice_tax_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_tax", "account_analytic_account", column: "account_analytic_id", name: "account_invoice_tax_account_analytic_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_tax", "account_invoice", column: "invoice_id", name: "account_invoice_tax_invoice_id_fkey", on_delete: :cascade
  add_foreign_key "account_invoice_tax", "account_tax", column: "tax_id", name: "account_invoice_tax_tax_id_fkey", on_delete: :restrict
  add_foreign_key "account_invoice_tax", "res_company", column: "company_id", name: "account_invoice_tax_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_tax", "res_currency", column: "currency_id", name: "account_invoice_tax_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_tax", "res_users", column: "create_uid", name: "account_invoice_tax_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_invoice_tax", "res_users", column: "write_uid", name: "account_invoice_tax_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "account_account", column: "default_credit_account_id", name: "account_journal_default_credit_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "account_account", column: "default_debit_account_id", name: "account_journal_default_debit_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "account_account", column: "loss_account_id", name: "account_journal_loss_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "account_account", column: "profit_account_id", name: "account_journal_profit_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "ir_sequence", column: "refund_sequence_id", name: "account_journal_refund_sequence_id_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "ir_sequence", column: "sequence_id", name: "account_journal_sequence_id_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "res_company", column: "company_id", name: "account_journal_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "res_currency", column: "currency_id", name: "account_journal_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "res_partner_bank", column: "bank_account_id", name: "account_journal_bank_account_id_fkey", on_delete: :restrict
  add_foreign_key "account_journal", "res_users", column: "create_uid", name: "account_journal_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_journal", "res_users", column: "write_uid", name: "account_journal_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_journal_account_print_journal_rel", "account_journal", name: "account_journal_account_print_journal_r_account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_account_print_journal_rel", "account_print_journal", name: "account_journal_account_print_jou_account_print_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_account_report_partner_ledger_rel", "account_journal", name: "account_journal_account_report_partner__account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_account_report_partner_ledger_rel", "account_report_partner_ledger", name: "account_journal_account_repor_account_report_partner_ledge_fkey", on_delete: :cascade
  add_foreign_key "account_journal_account_tax_report_rel", "account_journal", name: "account_journal_account_tax_report_rel_account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_account_tax_report_rel", "account_tax_report", name: "account_journal_account_tax_report_r_account_tax_report_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_accounting_report_rel", "account_journal", name: "account_journal_accounting_report_rel_account_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_accounting_report_rel", "accounting_report", name: "account_journal_accounting_report_rel_accounting_report_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_inbound_payment_method_rel", "account_journal", column: "journal_id", name: "account_journal_inbound_payment_method_rel_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_inbound_payment_method_rel", "account_payment_method", column: "inbound_payment_method", name: "account_journal_inbound_payment_met_inbound_payment_method_fkey", on_delete: :cascade
  add_foreign_key "account_journal_outbound_payment_method_rel", "account_journal", column: "journal_id", name: "account_journal_outbound_payment_method_rel_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_outbound_payment_method_rel", "account_payment_method", column: "outbound_payment_method", name: "account_journal_outbound_payment_m_outbound_payment_method_fkey", on_delete: :cascade
  add_foreign_key "account_journal_type_rel", "account_account_type", column: "type_id", name: "account_journal_type_rel_type_id_fkey", on_delete: :cascade
  add_foreign_key "account_journal_type_rel", "account_journal", column: "journal_id", name: "account_journal_type_rel_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_move", "account_journal", column: "journal_id", name: "account_move_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_move", "account_partial_reconcile", column: "tax_cash_basis_rec_id", name: "account_move_tax_cash_basis_rec_id_fkey", on_delete: :nullify
  add_foreign_key "account_move", "res_company", column: "company_id", name: "account_move_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_move", "res_currency", column: "currency_id", name: "account_move_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_move", "res_partner", column: "partner_id", name: "account_move_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_move", "res_users", column: "create_uid", name: "account_move_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move", "res_users", column: "write_uid", name: "account_move_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_account", column: "account_id", name: "account_move_line_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_move_line", "account_account_type", column: "user_type_id", name: "account_move_line_user_type_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_analytic_account", column: "analytic_account_id", name: "account_move_line_analytic_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_bank_statement", column: "statement_id", name: "account_move_line_statement_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_bank_statement_line", column: "statement_line_id", name: "account_move_line_statement_line_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_full_reconcile", column: "full_reconcile_id", name: "account_move_line_full_reconcile_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_invoice", column: "invoice_id", name: "account_move_line_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_journal", column: "journal_id", name: "account_move_line_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_move", column: "move_id", name: "account_move_line_move_id_fkey", on_delete: :cascade
  add_foreign_key "account_move_line", "account_payment", column: "payment_id", name: "account_move_line_payment_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "account_tax", column: "tax_line_id", name: "account_move_line_tax_line_id_fkey", on_delete: :restrict
  add_foreign_key "account_move_line", "hr_expense", column: "expense_id", name: "account_move_line_expense_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "product_product", column: "product_id", name: "account_move_line_product_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "product_uom", name: "account_move_line_product_uom_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "res_company", column: "company_id", name: "account_move_line_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "res_currency", column: "company_currency_id", name: "account_move_line_company_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "res_currency", column: "currency_id", name: "account_move_line_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "res_partner", column: "partner_id", name: "account_move_line_partner_id_fkey", on_delete: :restrict
  add_foreign_key "account_move_line", "res_users", column: "create_uid", name: "account_move_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move_line", "res_users", column: "write_uid", name: "account_move_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move_line_account_tax_rel", "account_move_line", name: "account_move_line_account_tax_rel_account_move_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_move_line_account_tax_rel", "account_tax", name: "account_move_line_account_tax_rel_account_tax_id_fkey", on_delete: :cascade
  add_foreign_key "account_move_line_reconcile", "res_company", column: "company_id", name: "account_move_line_reconcile_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line_reconcile", "res_users", column: "create_uid", name: "account_move_line_reconcile_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move_line_reconcile", "res_users", column: "write_uid", name: "account_move_line_reconcile_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move_line_reconcile_writeoff", "account_account", column: "writeoff_acc_id", name: "account_move_line_reconcile_writeoff_writeoff_acc_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line_reconcile_writeoff", "account_analytic_account", column: "analytic_id", name: "account_move_line_reconcile_writeoff_analytic_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line_reconcile_writeoff", "account_journal", column: "journal_id", name: "account_move_line_reconcile_writeoff_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_line_reconcile_writeoff", "res_users", column: "create_uid", name: "account_move_line_reconcile_writeoff_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move_line_reconcile_writeoff", "res_users", column: "write_uid", name: "account_move_line_reconcile_writeoff_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move_reversal", "account_journal", column: "journal_id", name: "account_move_reversal_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_move_reversal", "res_users", column: "create_uid", name: "account_move_reversal_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_move_reversal", "res_users", column: "write_uid", name: "account_move_reversal_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_opening", "res_company", column: "company_id", name: "account_opening_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_opening", "res_users", column: "create_uid", name: "account_opening_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_opening", "res_users", column: "write_uid", name: "account_opening_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_partial_reconcile", "account_full_reconcile", column: "full_reconcile_id", name: "account_partial_reconcile_full_reconcile_id_fkey", on_delete: :nullify
  add_foreign_key "account_partial_reconcile", "account_move_line", column: "credit_move_id", name: "account_partial_reconcile_credit_move_id_fkey", on_delete: :nullify
  add_foreign_key "account_partial_reconcile", "account_move_line", column: "debit_move_id", name: "account_partial_reconcile_debit_move_id_fkey", on_delete: :nullify
  add_foreign_key "account_partial_reconcile", "res_company", column: "company_id", name: "account_partial_reconcile_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_partial_reconcile", "res_currency", column: "currency_id", name: "account_partial_reconcile_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_partial_reconcile", "res_users", column: "create_uid", name: "account_partial_reconcile_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_partial_reconcile", "res_users", column: "write_uid", name: "account_partial_reconcile_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "account_account", column: "writeoff_account_id", name: "account_payment_writeoff_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "account_journal", column: "destination_journal_id", name: "account_payment_destination_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "account_journal", column: "journal_id", name: "account_payment_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "account_payment_method", column: "payment_method_id", name: "account_payment_payment_method_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "payment_token", name: "account_payment_payment_token_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "payment_transaction", name: "account_payment_payment_transaction_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "res_company", column: "company_id", name: "account_payment_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "res_currency", column: "currency_id", name: "account_payment_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "res_partner", column: "partner_id", name: "account_payment_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "res_users", column: "create_uid", name: "account_payment_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_payment", "res_users", column: "write_uid", name: "account_payment_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_payment_method", "res_users", column: "create_uid", name: "account_payment_method_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_payment_method", "res_users", column: "write_uid", name: "account_payment_method_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_payment_term", "res_company", column: "company_id", name: "account_payment_term_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_payment_term", "res_users", column: "create_uid", name: "account_payment_term_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_payment_term", "res_users", column: "write_uid", name: "account_payment_term_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_payment_term_line", "account_payment_term", column: "payment_id", name: "account_payment_term_line_payment_id_fkey", on_delete: :cascade
  add_foreign_key "account_payment_term_line", "res_users", column: "create_uid", name: "account_payment_term_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_payment_term_line", "res_users", column: "write_uid", name: "account_payment_term_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_print_journal", "res_company", column: "company_id", name: "account_print_journal_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_print_journal", "res_users", column: "create_uid", name: "account_print_journal_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_print_journal", "res_users", column: "write_uid", name: "account_print_journal_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_reconcile_model", "account_account", column: "account_id", name: "account_reconcile_model_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_reconcile_model", "account_account", column: "second_account_id", name: "account_reconcile_model_second_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_reconcile_model", "account_analytic_account", column: "analytic_account_id", name: "account_reconcile_model_analytic_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_reconcile_model", "account_analytic_account", column: "second_analytic_account_id", name: "account_reconcile_model_second_analytic_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_reconcile_model", "account_journal", column: "journal_id", name: "account_reconcile_model_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_reconcile_model", "account_journal", column: "second_journal_id", name: "account_reconcile_model_second_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_reconcile_model", "account_tax", column: "second_tax_id", name: "account_reconcile_model_second_tax_id_fkey", on_delete: :restrict
  add_foreign_key "account_reconcile_model", "account_tax", column: "tax_id", name: "account_reconcile_model_tax_id_fkey", on_delete: :restrict
  add_foreign_key "account_reconcile_model", "res_company", column: "company_id", name: "account_reconcile_model_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_reconcile_model", "res_users", column: "create_uid", name: "account_reconcile_model_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_reconcile_model", "res_users", column: "write_uid", name: "account_reconcile_model_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_reconcile_model_template", "account_account_template", column: "account_id", name: "account_reconcile_model_template_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_reconcile_model_template", "account_account_template", column: "second_account_id", name: "account_reconcile_model_template_second_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_reconcile_model_template", "account_chart_template", column: "chart_template_id", name: "account_reconcile_model_template_chart_template_id_fkey", on_delete: :nullify
  add_foreign_key "account_reconcile_model_template", "account_tax_template", column: "second_tax_id", name: "account_reconcile_model_template_second_tax_id_fkey", on_delete: :restrict
  add_foreign_key "account_reconcile_model_template", "account_tax_template", column: "tax_id", name: "account_reconcile_model_template_tax_id_fkey", on_delete: :restrict
  add_foreign_key "account_reconcile_model_template", "res_users", column: "create_uid", name: "account_reconcile_model_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_reconcile_model_template", "res_users", column: "write_uid", name: "account_reconcile_model_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_register_payments", "account_journal", column: "journal_id", name: "account_register_payments_journal_id_fkey", on_delete: :nullify
  add_foreign_key "account_register_payments", "account_payment_method", column: "payment_method_id", name: "account_register_payments_payment_method_id_fkey", on_delete: :nullify
  add_foreign_key "account_register_payments", "res_currency", column: "currency_id", name: "account_register_payments_currency_id_fkey", on_delete: :nullify
  add_foreign_key "account_register_payments", "res_partner", column: "partner_id", name: "account_register_payments_partner_id_fkey", on_delete: :nullify
  add_foreign_key "account_register_payments", "res_users", column: "create_uid", name: "account_register_payments_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_register_payments", "res_users", column: "write_uid", name: "account_register_payments_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_report_general_ledger", "res_company", column: "company_id", name: "account_report_general_ledger_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_report_general_ledger", "res_users", column: "create_uid", name: "account_report_general_ledger_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_report_general_ledger", "res_users", column: "write_uid", name: "account_report_general_ledger_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_report_general_ledger_journal_rel", "account_journal", column: "journal_id", name: "account_report_general_ledger_journal_rel_journal_id_fkey", on_delete: :cascade
  add_foreign_key "account_report_general_ledger_journal_rel", "account_report_general_ledger", column: "account_id", name: "account_report_general_ledger_journal_rel_account_id_fkey", on_delete: :cascade
  add_foreign_key "account_report_partner_ledger", "res_company", column: "company_id", name: "account_report_partner_ledger_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_report_partner_ledger", "res_users", column: "create_uid", name: "account_report_partner_ledger_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_report_partner_ledger", "res_users", column: "write_uid", name: "account_report_partner_ledger_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax", "account_account", column: "account_id", name: "account_tax_account_id_fkey", on_delete: :restrict
  add_foreign_key "account_tax", "account_account", column: "cash_basis_account", name: "account_tax_cash_basis_account_fkey", on_delete: :nullify
  add_foreign_key "account_tax", "account_account", column: "cash_basis_base_account_id", name: "account_tax_cash_basis_base_account_id_fkey", on_delete: :nullify
  add_foreign_key "account_tax", "account_account", column: "refund_account_id", name: "account_tax_refund_account_id_fkey", on_delete: :restrict
  add_foreign_key "account_tax", "account_tax_group", column: "tax_group_id", name: "account_tax_tax_group_id_fkey", on_delete: :nullify
  add_foreign_key "account_tax", "res_company", column: "company_id", name: "account_tax_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_tax", "res_users", column: "create_uid", name: "account_tax_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax", "res_users", column: "write_uid", name: "account_tax_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax_account_tag", "account_account_tag", name: "account_tax_account_tag_account_account_tag_id_fkey", on_delete: :cascade
  add_foreign_key "account_tax_account_tag", "account_tax", name: "account_tax_account_tag_account_tax_id_fkey", on_delete: :cascade
  add_foreign_key "account_tax_filiation_rel", "account_tax", column: "child_tax", name: "account_tax_filiation_rel_child_tax_fkey", on_delete: :cascade
  add_foreign_key "account_tax_filiation_rel", "account_tax", column: "parent_tax", name: "account_tax_filiation_rel_parent_tax_fkey", on_delete: :cascade
  add_foreign_key "account_tax_group", "res_users", column: "create_uid", name: "account_tax_group_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax_group", "res_users", column: "write_uid", name: "account_tax_group_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax_pos_order_line_rel", "account_tax", name: "account_tax_pos_order_line_rel_account_tax_id_fkey", on_delete: :cascade
  add_foreign_key "account_tax_pos_order_line_rel", "pos_order_line", name: "account_tax_pos_order_line_rel_pos_order_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_tax_report", "res_company", column: "company_id", name: "account_tax_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_tax_report", "res_users", column: "create_uid", name: "account_tax_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax_report", "res_users", column: "write_uid", name: "account_tax_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax_sale_advance_payment_inv_rel", "account_tax", name: "account_tax_sale_advance_payment_inv_rel_account_tax_id_fkey", on_delete: :cascade
  add_foreign_key "account_tax_sale_advance_payment_inv_rel", "sale_advance_payment_inv", name: "account_tax_sale_advance_payme_sale_advance_payment_inv_id_fkey", on_delete: :cascade
  add_foreign_key "account_tax_sale_order_line_rel", "account_tax", name: "account_tax_sale_order_line_rel_account_tax_id_fkey", on_delete: :cascade
  add_foreign_key "account_tax_sale_order_line_rel", "sale_order_line", name: "account_tax_sale_order_line_rel_sale_order_line_id_fkey", on_delete: :cascade
  add_foreign_key "account_tax_template", "account_account_template", column: "account_id", name: "account_tax_template_account_id_fkey", on_delete: :restrict
  add_foreign_key "account_tax_template", "account_account_template", column: "cash_basis_account", name: "account_tax_template_cash_basis_account_fkey", on_delete: :nullify
  add_foreign_key "account_tax_template", "account_account_template", column: "refund_account_id", name: "account_tax_template_refund_account_id_fkey", on_delete: :restrict
  add_foreign_key "account_tax_template", "account_chart_template", column: "chart_template_id", name: "account_tax_template_chart_template_id_fkey", on_delete: :nullify
  add_foreign_key "account_tax_template", "account_tax_group", column: "tax_group_id", name: "account_tax_template_tax_group_id_fkey", on_delete: :nullify
  add_foreign_key "account_tax_template", "res_company", column: "company_id", name: "account_tax_template_company_id_fkey", on_delete: :nullify
  add_foreign_key "account_tax_template", "res_users", column: "create_uid", name: "account_tax_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax_template", "res_users", column: "write_uid", name: "account_tax_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "account_tax_template_filiation_rel", "account_tax_template", column: "child_tax", name: "account_tax_template_filiation_rel_child_tax_fkey", on_delete: :cascade
  add_foreign_key "account_tax_template_filiation_rel", "account_tax_template", column: "parent_tax", name: "account_tax_template_filiation_rel_parent_tax_fkey", on_delete: :cascade
  add_foreign_key "account_unreconcile", "res_users", column: "create_uid", name: "account_unreconcile_create_uid_fkey", on_delete: :nullify
  add_foreign_key "account_unreconcile", "res_users", column: "write_uid", name: "account_unreconcile_write_uid_fkey", on_delete: :nullify
  add_foreign_key "accounting_report", "account_financial_report", column: "account_report_id", name: "accounting_report_account_report_id_fkey", on_delete: :nullify
  add_foreign_key "accounting_report", "res_company", column: "company_id", name: "accounting_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "accounting_report", "res_users", column: "create_uid", name: "accounting_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "accounting_report", "res_users", column: "write_uid", name: "accounting_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admission_analysis", "op_course", column: "course_id", name: "admission_analysis_course_id_fkey", on_delete: :nullify
  add_foreign_key "admission_analysis", "res_users", column: "create_uid", name: "admission_analysis_create_uid_fkey", on_delete: :nullify
  add_foreign_key "admission_analysis", "res_users", column: "write_uid", name: "admission_analysis_write_uid_fkey", on_delete: :nullify
  add_foreign_key "admission_sent_email", "op_batch", column: "batch_id", name: "admission_sent_email_batch_id_fkey", on_delete: :nullify
  add_foreign_key "admission_sent_email", "op_student", column: "student_id", name: "admission_sent_email_student_id_fkey", on_delete: :nullify
  add_foreign_key "admission_sent_email", "res_users", column: "create_uid", name: "admission_sent_email_create_uid_fkey", on_delete: :nullify
  add_foreign_key "admission_sent_email", "res_users", column: "write_uid", name: "admission_sent_email_write_uid_fkey", on_delete: :nullify
  add_foreign_key "answer_marks", "user_answers"
  add_foreign_key "asset_depreciation_confirmation_wizard", "res_users", column: "create_uid", name: "asset_depreciation_confirmation_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_depreciation_confirmation_wizard", "res_users", column: "write_uid", name: "asset_depreciation_confirmation_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_mass_create", "bt_asset_category", column: "category_id", name: "asset_mass_create_category_id_fkey", on_delete: :nullify
  add_foreign_key "asset_mass_create", "bt_asset_location", column: "current_loc_id", name: "asset_mass_create_current_loc_id_fkey", on_delete: :nullify
  add_foreign_key "asset_mass_create", "bt_asset_status", column: "asset_status_id", name: "asset_mass_create_asset_status_id_fkey", on_delete: :nullify
  add_foreign_key "asset_mass_create", "res_users", column: "create_uid", name: "asset_mass_create_create_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_mass_create", "res_users", column: "write_uid", name: "asset_mass_create_write_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_modify", "res_users", column: "create_uid", name: "asset_modify_create_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_modify", "res_users", column: "write_uid", name: "asset_modify_write_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "bt_asset", column: "asset_id", name: "asset_move_asset_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "bt_asset_location", column: "from_loc_id", name: "asset_move_from_loc_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "bt_asset_location", column: "to_loc_id", name: "asset_move_to_loc_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "hr_employee", column: "employee_id", name: "asset_move_employee_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "hr_employee", column: "manager_faculty_id", name: "asset_move_manager_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "hr_employee", column: "manager_id", name: "asset_move_manager_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "op_batch", column: "batch_id", name: "asset_move_batch_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "op_course", column: "course_id", name: "asset_move_course_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "op_faculty", column: "faculty_id", name: "asset_move_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "op_student", column: "student_id", name: "asset_move_student_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "res_company", column: "company_id", name: "asset_move_company_id_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "res_users", column: "create_uid", name: "asset_move_create_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_move", "res_users", column: "write_uid", name: "asset_move_write_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_move_bt_asset_rel", "asset_move", name: "asset_move_bt_asset_rel_asset_move_id_fkey", on_delete: :cascade
  add_foreign_key "asset_move_bt_asset_rel", "bt_asset", name: "asset_move_bt_asset_rel_bt_asset_id_fkey", on_delete: :cascade
  add_foreign_key "asset_table", "res_users", column: "create_uid", name: "asset_table_create_uid_fkey", on_delete: :nullify
  add_foreign_key "asset_table", "res_users", column: "write_uid", name: "asset_table_write_uid_fkey", on_delete: :nullify
  add_foreign_key "assign_lead", "crm_stage", column: "stage_id", name: "assign_lead_stage_id_fkey", on_delete: :nullify
  add_foreign_key "assign_lead", "crm_team", column: "team_id", name: "assign_lead_team_id_fkey", on_delete: :nullify
  add_foreign_key "assign_lead", "res_users", column: "create_uid", name: "assign_lead_create_uid_fkey", on_delete: :nullify
  add_foreign_key "assign_lead", "res_users", column: "user_id", name: "assign_lead_user_id_fkey", on_delete: :nullify
  add_foreign_key "assign_lead", "res_users", column: "write_uid", name: "assign_lead_write_uid_fkey", on_delete: :nullify
  add_foreign_key "attendance_company_rel", "export_attendance", column: "atten_id", name: "attendance_company_rel_atten_id_fkey", on_delete: :cascade
  add_foreign_key "attendance_company_rel", "res_company", column: "com_id", name: "attendance_company_rel_com_id_fkey", on_delete: :cascade
  add_foreign_key "attendance_device_zk", "res_company", column: "company_id", name: "attendance_device_zk_company_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_device_zk", "res_users", column: "create_uid", name: "attendance_device_zk_create_uid_fkey", on_delete: :nullify
  add_foreign_key "attendance_device_zk", "res_users", column: "write_uid", name: "attendance_device_zk_write_uid_fkey", on_delete: :nullify
  add_foreign_key "attendance_device_zk_line", "attendance_device_zk", column: "zk_id", name: "attendance_device_zk_line_zk_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_device_zk_line", "res_users", column: "create_uid", name: "attendance_device_zk_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "attendance_device_zk_line", "res_users", column: "write_uid", name: "attendance_device_zk_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "attendance_employee_rel", "export_attendance", column: "atten_id", name: "attendance_employee_rel_atten_id_fkey", on_delete: :cascade
  add_foreign_key "attendance_employee_rel", "hr_employee", column: "emp_id", name: "attendance_employee_rel_emp_id_fkey", on_delete: :cascade
  add_foreign_key "attendance_report", "hr_employee", column: "employee_id", name: "attendance_report_employee_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_report", "hr_job", column: "job_id", name: "attendance_report_job_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_report", "res_company", column: "company_id", name: "attendance_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_report", "res_users", column: "create_uid", name: "attendance_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "attendance_report", "res_users", column: "write_uid", name: "attendance_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "attendance_tutor", "op_batch", column: "batch_id", name: "attendance_tutor_batch_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_tutor", "op_course", column: "course_id", name: "attendance_tutor_course_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_tutor", "op_faculty", column: "tutor_id", name: "attendance_tutor_tutor_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_tutor", "op_session", column: "session_id", name: "attendance_tutor_session_id_fkey", on_delete: :nullify
  add_foreign_key "attendance_tutor", "res_users", column: "create_uid", name: "attendance_tutor_create_uid_fkey", on_delete: :nullify
  add_foreign_key "attendance_tutor", "res_users", column: "write_uid", name: "attendance_tutor_write_uid_fkey", on_delete: :nullify
  add_foreign_key "auth_oauth_provider", "res_users", column: "create_uid", name: "auth_oauth_provider_create_uid_fkey", on_delete: :nullify
  add_foreign_key "auth_oauth_provider", "res_users", column: "write_uid", name: "auth_oauth_provider_write_uid_fkey", on_delete: :nullify
  add_foreign_key "badge_unlocked_definition_rel", "gamification_badge", name: "badge_unlocked_definition_rel_gamification_badge_id_fkey", on_delete: :cascade
  add_foreign_key "badge_unlocked_definition_rel", "gamification_goal_definition", name: "badge_unlocked_definition_rel_gamification_goal_definition_fkey", on_delete: :cascade
  add_foreign_key "barcode_nomenclature", "res_users", column: "create_uid", name: "barcode_nomenclature_create_uid_fkey", on_delete: :nullify
  add_foreign_key "barcode_nomenclature", "res_users", column: "write_uid", name: "barcode_nomenclature_write_uid_fkey", on_delete: :nullify
  add_foreign_key "barcode_rule", "barcode_nomenclature", name: "barcode_rule_barcode_nomenclature_id_fkey", on_delete: :nullify
  add_foreign_key "barcode_rule", "res_users", column: "create_uid", name: "barcode_rule_create_uid_fkey", on_delete: :nullify
  add_foreign_key "barcode_rule", "res_users", column: "write_uid", name: "barcode_rule_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_automation", "ir_act_server", column: "action_server_id", name: "base_automation_action_server_id_fkey", on_delete: :restrict
  add_foreign_key "base_automation", "ir_model_fields", column: "trg_date_id", name: "base_automation_trg_date_id_fkey", on_delete: :nullify
  add_foreign_key "base_automation", "res_users", column: "create_uid", name: "base_automation_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_automation", "res_users", column: "write_uid", name: "base_automation_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_automation", "resource_calendar", column: "trg_date_calendar_id", name: "base_automation_trg_date_calendar_id_fkey", on_delete: :nullify
  add_foreign_key "base_automation_lead_test", "res_partner", column: "partner_id", name: "base_automation_lead_test_partner_id_fkey", on_delete: :nullify
  add_foreign_key "base_automation_lead_test", "res_users", column: "create_uid", name: "base_automation_lead_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_automation_lead_test", "res_users", column: "user_id", name: "base_automation_lead_test_user_id_fkey", on_delete: :nullify
  add_foreign_key "base_automation_lead_test", "res_users", column: "write_uid", name: "base_automation_lead_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_automation_line_test", "base_automation_lead_test", column: "lead_id", name: "base_automation_line_test_lead_id_fkey", on_delete: :cascade
  add_foreign_key "base_automation_line_test", "res_users", column: "create_uid", name: "base_automation_line_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_automation_line_test", "res_users", column: "user_id", name: "base_automation_line_test_user_id_fkey", on_delete: :nullify
  add_foreign_key "base_automation_line_test", "res_users", column: "write_uid", name: "base_automation_line_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_import", "res_users", column: "create_uid", name: "base_import_import_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_import", "res_users", column: "write_uid", name: "base_import_import_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char", "res_users", column: "create_uid", name: "base_import_tests_models_char_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char", "res_users", column: "write_uid", name: "base_import_tests_models_char_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_noreadonly", "res_users", column: "create_uid", name: "base_import_tests_models_char_noreadonly_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_noreadonly", "res_users", column: "write_uid", name: "base_import_tests_models_char_noreadonly_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_readonly", "res_users", column: "create_uid", name: "base_import_tests_models_char_readonly_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_readonly", "res_users", column: "write_uid", name: "base_import_tests_models_char_readonly_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_required", "res_users", column: "create_uid", name: "base_import_tests_models_char_required_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_required", "res_users", column: "write_uid", name: "base_import_tests_models_char_required_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_states", "res_users", column: "create_uid", name: "base_import_tests_models_char_states_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_states", "res_users", column: "write_uid", name: "base_import_tests_models_char_states_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_stillreadonly", "res_users", column: "create_uid", name: "base_import_tests_models_char_stillreadonly_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_char_stillreadonly", "res_users", column: "write_uid", name: "base_import_tests_models_char_stillreadonly_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o", "base_import_tests_models_m2o_related", column: "value", name: "base_import_tests_models_m2o_value_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o", "res_users", column: "create_uid", name: "base_import_tests_models_m2o_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o", "res_users", column: "write_uid", name: "base_import_tests_models_m2o_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o_related", "res_users", column: "create_uid", name: "base_import_tests_models_m2o_related_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o_related", "res_users", column: "write_uid", name: "base_import_tests_models_m2o_related_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o_required", "base_import_tests_models_m2o_required_related", column: "value", name: "base_import_tests_models_m2o_required_value_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o_required", "res_users", column: "create_uid", name: "base_import_tests_models_m2o_required_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o_required", "res_users", column: "write_uid", name: "base_import_tests_models_m2o_required_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o_required_related", "res_users", column: "create_uid", name: "base_import_tests_models_m2o_required_related_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_m2o_required_related", "res_users", column: "write_uid", name: "base_import_tests_models_m2o_required_related_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_o2m", "res_users", column: "create_uid", name: "base_import_tests_models_o2m_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_o2m", "res_users", column: "write_uid", name: "base_import_tests_models_o2m_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_o2m_child", "base_import_tests_models_o2m", column: "parent_id", name: "base_import_tests_models_o2m_child_parent_id_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_o2m_child", "res_users", column: "create_uid", name: "base_import_tests_models_o2m_child_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_o2m_child", "res_users", column: "write_uid", name: "base_import_tests_models_o2m_child_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_preview", "res_users", column: "create_uid", name: "base_import_tests_models_preview_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_import_tests_models_preview", "res_users", column: "write_uid", name: "base_import_tests_models_preview_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_export", "res_users", column: "create_uid", name: "base_language_export_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_export", "res_users", column: "write_uid", name: "base_language_export_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_import", "res_users", column: "create_uid", name: "base_language_import_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_import", "res_users", column: "write_uid", name: "base_language_import_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_install", "res_users", column: "create_uid", name: "base_language_install_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_install", "res_users", column: "write_uid", name: "base_language_install_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_install_website_rel", "base_language_install", name: "base_language_install_website_rel_base_language_install_id_fkey", on_delete: :cascade
  add_foreign_key "base_language_install_website_rel", "website", name: "base_language_install_website_rel_website_id_fkey", on_delete: :cascade
  add_foreign_key "base_language_update", "res_users", column: "create_uid", name: "base_language_update_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_update", "res_users", column: "write_uid", name: "base_language_update_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_language_update_ir_module_module_rel", "base_language_update", name: "base_language_update_ir_module_mod_base_language_update_id_fkey", on_delete: :cascade
  add_foreign_key "base_language_update_ir_module_module_rel", "ir_module_module", name: "base_language_update_ir_module_module__ir_module_module_id_fkey", on_delete: :cascade
  add_foreign_key "base_module_uninstall", "ir_module_module", column: "module_id", name: "base_module_uninstall_module_id_fkey", on_delete: :nullify
  add_foreign_key "base_module_uninstall", "res_users", column: "create_uid", name: "base_module_uninstall_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_module_uninstall", "res_users", column: "write_uid", name: "base_module_uninstall_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_module_update", "res_users", column: "create_uid", name: "base_module_update_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_module_update", "res_users", column: "write_uid", name: "base_module_update_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_module_upgrade", "res_users", column: "create_uid", name: "base_module_upgrade_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_module_upgrade", "res_users", column: "write_uid", name: "base_module_upgrade_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_partner_merge_automatic_wizard", "base_partner_merge_line", column: "current_line_id", name: "base_partner_merge_automatic_wizard_current_line_id_fkey", on_delete: :nullify
  add_foreign_key "base_partner_merge_automatic_wizard", "res_partner", column: "dst_partner_id", name: "base_partner_merge_automatic_wizard_dst_partner_id_fkey", on_delete: :nullify
  add_foreign_key "base_partner_merge_automatic_wizard", "res_users", column: "create_uid", name: "base_partner_merge_automatic_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_partner_merge_automatic_wizard", "res_users", column: "write_uid", name: "base_partner_merge_automatic_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_partner_merge_automatic_wizard_res_partner_rel", "base_partner_merge_automatic_wizard", name: "base_partner_merge_automatic__base_partner_merge_automatic_fkey", on_delete: :cascade
  add_foreign_key "base_partner_merge_automatic_wizard_res_partner_rel", "res_partner", name: "base_partner_merge_automatic_wizard_res_par_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "base_partner_merge_line", "base_partner_merge_automatic_wizard", column: "wizard_id", name: "base_partner_merge_line_wizard_id_fkey", on_delete: :nullify
  add_foreign_key "base_partner_merge_line", "res_users", column: "create_uid", name: "base_partner_merge_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_partner_merge_line", "res_users", column: "write_uid", name: "base_partner_merge_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "base_update_translations", "res_users", column: "create_uid", name: "base_update_translations_create_uid_fkey", on_delete: :nullify
  add_foreign_key "base_update_translations", "res_users", column: "write_uid", name: "base_update_translations_write_uid_fkey", on_delete: :nullify
  add_foreign_key "batch_reject_wizard", "res_users", column: "create_uid", name: "batch_reject_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "batch_reject_wizard", "res_users", column: "write_uid", name: "batch_reject_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "asset_table", column: "asset_table", name: "bt_asset_asset_table_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "bt_asset_category", column: "categ_id", name: "bt_asset_categ_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "bt_asset_category", column: "category_id", name: "bt_asset_category_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "bt_asset_category", column: "parent_id", name: "bt_asset_parent_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "bt_asset_location", column: "current_loc_id", name: "bt_asset_current_loc_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "bt_asset_status", column: "asset_status_id", name: "bt_asset_asset_status_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "res_company", column: "company_id", name: "bt_asset_company_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "res_users", column: "create_uid", name: "bt_asset_create_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset", "res_users", column: "write_uid", name: "bt_asset_write_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_category", "bt_asset_category", column: "parent_id", name: "bt_asset_category_parent_id_fkey", on_delete: :cascade
  add_foreign_key "bt_asset_category", "res_users", column: "create_uid", name: "bt_asset_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_category", "res_users", column: "write_uid", name: "bt_asset_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_location", "res_users", column: "create_uid", name: "bt_asset_location_create_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_location", "res_users", column: "write_uid", name: "bt_asset_location_write_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_move", "bt_asset", column: "asset_id", name: "bt_asset_move_asset_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_move", "bt_asset_location", column: "from_loc_id", name: "bt_asset_move_from_loc_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_move", "bt_asset_location", column: "to_loc_id", name: "bt_asset_move_to_loc_id_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_move", "res_users", column: "create_uid", name: "bt_asset_move_create_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_move", "res_users", column: "write_uid", name: "bt_asset_move_write_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_status", "res_users", column: "create_uid", name: "bt_asset_status_create_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_asset_status", "res_users", column: "write_uid", name: "bt_asset_status_write_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_hr_overtime", "hr_attendance", column: "attendance_id", name: "bt_hr_overtime_attendance_id_fkey", on_delete: :nullify
  add_foreign_key "bt_hr_overtime", "hr_employee", column: "employee_id", name: "bt_hr_overtime_employee_id_fkey", on_delete: :nullify
  add_foreign_key "bt_hr_overtime", "hr_employee", column: "manager_id", name: "bt_hr_overtime_manager_id_fkey", on_delete: :nullify
  add_foreign_key "bt_hr_overtime", "res_company", column: "company_id", name: "bt_hr_overtime_company_id_fkey", on_delete: :nullify
  add_foreign_key "bt_hr_overtime", "res_users", column: "create_uid", name: "bt_hr_overtime_create_uid_fkey", on_delete: :nullify
  add_foreign_key "bt_hr_overtime", "res_users", column: "write_uid", name: "bt_hr_overtime_write_uid_fkey", on_delete: :nullify
  add_foreign_key "bus_bus", "res_users", column: "create_uid", name: "bus_bus_create_uid_fkey", on_delete: :nullify
  add_foreign_key "bus_bus", "res_users", column: "write_uid", name: "bus_bus_write_uid_fkey", on_delete: :nullify
  add_foreign_key "bus_presence", "res_users", column: "user_id", name: "bus_presence_user_id_fkey", on_delete: :cascade
  add_foreign_key "bve_view", "res_users", column: "create_uid", name: "bve_view_create_uid_fkey", on_delete: :nullify
  add_foreign_key "bve_view", "res_users", column: "write_uid", name: "bve_view_write_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_alarm", "res_users", column: "create_uid", name: "calendar_alarm_create_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_alarm", "res_users", column: "write_uid", name: "calendar_alarm_write_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_alarm_calendar_event_rel", "calendar_alarm", name: "calendar_alarm_calendar_event_rel_calendar_alarm_id_fkey", on_delete: :cascade
  add_foreign_key "calendar_alarm_calendar_event_rel", "calendar_event", name: "calendar_alarm_calendar_event_rel_calendar_event_id_fkey", on_delete: :cascade
  add_foreign_key "calendar_attendee", "calendar_event", column: "event_id", name: "calendar_attendee_event_id_fkey", on_delete: :cascade
  add_foreign_key "calendar_attendee", "res_partner", column: "partner_id", name: "calendar_attendee_partner_id_fkey", on_delete: :nullify
  add_foreign_key "calendar_attendee", "res_users", column: "create_uid", name: "calendar_attendee_create_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_attendee", "res_users", column: "write_uid", name: "calendar_attendee_write_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_contacts", "res_partner", column: "partner_id", name: "calendar_contacts_partner_id_fkey", on_delete: :nullify
  add_foreign_key "calendar_contacts", "res_users", column: "create_uid", name: "calendar_contacts_create_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_contacts", "res_users", column: "user_id", name: "calendar_contacts_user_id_fkey", on_delete: :nullify
  add_foreign_key "calendar_contacts", "res_users", column: "write_uid", name: "calendar_contacts_write_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_event", "crm_lead", column: "opportunity_id", name: "calendar_event_opportunity_id_fkey", on_delete: :nullify
  add_foreign_key "calendar_event", "crm_phonecall", column: "phonecall_id", name: "calendar_event_phonecall_id_fkey", on_delete: :nullify
  add_foreign_key "calendar_event", "hr_applicant", column: "applicant_id", name: "calendar_event_applicant_id_fkey", on_delete: :nullify
  add_foreign_key "calendar_event", "ir_model", column: "res_model_id", name: "calendar_event_res_model_id_fkey", on_delete: :cascade
  add_foreign_key "calendar_event", "res_users", column: "create_uid", name: "calendar_event_create_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_event", "res_users", column: "user_id", name: "calendar_event_user_id_fkey", on_delete: :nullify
  add_foreign_key "calendar_event", "res_users", column: "write_uid", name: "calendar_event_write_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_event_res_partner_rel", "calendar_event", name: "calendar_event_res_partner_rel_calendar_event_id_fkey", on_delete: :cascade
  add_foreign_key "calendar_event_res_partner_rel", "res_partner", name: "calendar_event_res_partner_rel_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "calendar_event_type", "res_users", column: "create_uid", name: "calendar_event_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "calendar_event_type", "res_users", column: "write_uid", name: "calendar_event_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "cash_box_in", "res_users", column: "create_uid", name: "cash_box_in_create_uid_fkey", on_delete: :nullify
  add_foreign_key "cash_box_in", "res_users", column: "write_uid", name: "cash_box_in_write_uid_fkey", on_delete: :nullify
  add_foreign_key "cash_box_out", "res_users", column: "create_uid", name: "cash_box_out_create_uid_fkey", on_delete: :nullify
  add_foreign_key "cash_box_out", "res_users", column: "write_uid", name: "cash_box_out_write_uid_fkey", on_delete: :nullify
  add_foreign_key "change_password_user", "change_password_wizard", column: "wizard_id", name: "change_password_user_wizard_id_fkey", on_delete: :nullify
  add_foreign_key "change_password_user", "res_users", column: "create_uid", name: "change_password_user_create_uid_fkey", on_delete: :nullify
  add_foreign_key "change_password_user", "res_users", column: "user_id", name: "change_password_user_user_id_fkey", on_delete: :cascade
  add_foreign_key "change_password_user", "res_users", column: "write_uid", name: "change_password_user_write_uid_fkey", on_delete: :nullify
  add_foreign_key "change_password_wizard", "res_users", column: "create_uid", name: "change_password_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "change_password_wizard", "res_users", column: "write_uid", name: "change_password_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "comments", "comments", column: "user_id", name: "comments_user_id_fkey"
  add_foreign_key "course_categ", "res_users", column: "create_uid", name: "course_categ_create_uid_fkey", on_delete: :nullify
  add_foreign_key "course_categ", "res_users", column: "write_uid", name: "course_categ_write_uid_fkey", on_delete: :nullify
  add_foreign_key "course_description", "op_course"
  add_foreign_key "crm_claim", "crm_claim_category", column: "categ_id", name: "crm_claim_categ_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "crm_claim_stage", column: "stage_id", name: "crm_claim_stage_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "crm_team", column: "team_id", name: "crm_claim_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "op_batch", column: "from_batch_id", name: "crm_claim_from_batch_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "op_batch", column: "to_batch_id", name: "crm_claim_to_batch_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "op_course", column: "from_course_id", name: "crm_claim_from_course_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "op_course", column: "to_course_id", name: "crm_claim_to_course_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "op_student", column: "student_id", name: "crm_claim_student_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "res_company", column: "company_id", name: "crm_claim_company_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "res_company", column: "from_company_id", name: "crm_claim_from_company_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "res_company", column: "to_company_id", name: "crm_claim_to_company_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "res_partner", column: "partner_id", name: "crm_claim_partner_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "res_users", column: "create_uid", name: "crm_claim_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "res_users", column: "user_id", name: "crm_claim_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim", "res_users", column: "write_uid", name: "crm_claim_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_claim_category", "crm_team", column: "team_id", name: "crm_claim_category_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_claim_category", "res_users", column: "create_uid", name: "crm_claim_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_claim_category", "res_users", column: "write_uid", name: "crm_claim_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_claim_sale_order_rel", "crm_claim", name: "crm_claim_sale_order_rel_crm_claim_id_fkey", on_delete: :cascade
  add_foreign_key "crm_claim_sale_order_rel", "sale_order", name: "crm_claim_sale_order_rel_sale_order_id_fkey", on_delete: :cascade
  add_foreign_key "crm_claim_stage", "res_users", column: "create_uid", name: "crm_claim_stage_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_claim_stage", "res_users", column: "write_uid", name: "crm_claim_stage_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "crm_lost_reason", column: "lost_reason", name: "crm_lead_lost_reason_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "crm_stage", column: "stage_id", name: "crm_lead_stage_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "crm_team", column: "team_id", name: "crm_lead_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_company", column: "company_id", name: "crm_lead_company_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_country", column: "country_id", name: "crm_lead_country_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_country_state", column: "state_id", name: "crm_lead_state_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_partner", column: "partner_id", name: "crm_lead_partner_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_partner_title", column: "title", name: "crm_lead_title_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_users", column: "convert_uid", name: "crm_lead_convert_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_users", column: "create_uid", name: "crm_lead_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_users", column: "user_id", name: "crm_lead_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "res_users", column: "write_uid", name: "crm_lead_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "utm_campaign", column: "campaign_id", name: "crm_lead_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "utm_medium", column: "medium_id", name: "crm_lead_medium_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead", "utm_source", column: "source_id", name: "crm_lead_source_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner", "crm_team", column: "team_id", name: "crm_lead2opportunity_partner_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner", "res_partner", column: "partner_id", name: "crm_lead2opportunity_partner_partner_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner", "res_users", column: "create_uid", name: "crm_lead2opportunity_partner_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner", "res_users", column: "user_id", name: "crm_lead2opportunity_partner_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner", "res_users", column: "write_uid", name: "crm_lead2opportunity_partner_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner_mass", "crm_team", column: "team_id", name: "crm_lead2opportunity_partner_mass_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner_mass", "res_partner", column: "partner_id", name: "crm_lead2opportunity_partner_mass_partner_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner_mass", "res_users", column: "create_uid", name: "crm_lead2opportunity_partner_mass_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner_mass", "res_users", column: "user_id", name: "crm_lead2opportunity_partner_mass_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner_mass", "res_users", column: "write_uid", name: "crm_lead2opportunity_partner_mass_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead2opportunity_partner_mass_res_users_rel", "crm_lead2opportunity_partner_mass", name: "crm_lead2opportunity_partner__crm_lead2opportunity_partner_fkey", on_delete: :cascade
  add_foreign_key "crm_lead2opportunity_partner_mass_res_users_rel", "res_users", column: "res_users_id", name: "crm_lead2opportunity_partner_mass_res_users_r_res_users_id_fkey", on_delete: :cascade
  add_foreign_key "crm_lead_crm_lead2opportunity_partner_mass_rel", "crm_lead", name: "crm_lead_crm_lead2opportunity_partner_mass_rel_crm_lead_id_fkey", on_delete: :cascade
  add_foreign_key "crm_lead_crm_lead2opportunity_partner_mass_rel", "crm_lead2opportunity_partner_mass", name: "crm_lead_crm_lead2opportunit_crm_lead2opportunity_partner_fkey1", on_delete: :cascade
  add_foreign_key "crm_lead_crm_lead2opportunity_partner_rel", "crm_lead", name: "crm_lead_crm_lead2opportunity_partner_rel_crm_lead_id_fkey", on_delete: :cascade
  add_foreign_key "crm_lead_crm_lead2opportunity_partner_rel", "crm_lead2opportunity_partner", name: "crm_lead_crm_lead2opportunity_crm_lead2opportunity_partner_fkey", on_delete: :cascade
  add_foreign_key "crm_lead_lost", "crm_lost_reason", column: "lost_reason_id", name: "crm_lead_lost_lost_reason_id_fkey", on_delete: :nullify
  add_foreign_key "crm_lead_lost", "res_users", column: "create_uid", name: "crm_lead_lost_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead_lost", "res_users", column: "write_uid", name: "crm_lead_lost_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead_tag", "res_users", column: "create_uid", name: "crm_lead_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead_tag", "res_users", column: "write_uid", name: "crm_lead_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lead_tag_rel", "crm_lead", column: "lead_id", name: "crm_lead_tag_rel_lead_id_fkey", on_delete: :cascade
  add_foreign_key "crm_lead_tag_rel", "crm_lead_tag", column: "tag_id", name: "crm_lead_tag_rel_tag_id_fkey", on_delete: :cascade
  add_foreign_key "crm_lost_reason", "res_users", column: "create_uid", name: "crm_lost_reason_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_lost_reason", "res_users", column: "write_uid", name: "crm_lost_reason_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_merge_opportunity", "crm_team", column: "team_id", name: "crm_merge_opportunity_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_merge_opportunity", "res_users", column: "create_uid", name: "crm_merge_opportunity_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_merge_opportunity", "res_users", column: "user_id", name: "crm_merge_opportunity_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_merge_opportunity", "res_users", column: "write_uid", name: "crm_merge_opportunity_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_partner_binding", "res_partner", column: "partner_id", name: "crm_partner_binding_partner_id_fkey", on_delete: :nullify
  add_foreign_key "crm_partner_binding", "res_users", column: "create_uid", name: "crm_partner_binding_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_partner_binding", "res_users", column: "write_uid", name: "crm_partner_binding_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "crm_lead", column: "opportunity_id", name: "crm_phonecall_opportunity_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "crm_team", column: "team_id", name: "crm_phonecall_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "res_company", column: "company_id", name: "crm_phonecall_company_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "res_partner", column: "partner_id", name: "crm_phonecall_partner_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "res_users", column: "create_uid", name: "crm_phonecall_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "res_users", column: "user_id", name: "crm_phonecall_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "res_users", column: "write_uid", name: "crm_phonecall_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "utm_campaign", column: "campaign_id", name: "crm_phonecall_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "utm_medium", column: "medium_id", name: "crm_phonecall_medium_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall", "utm_source", column: "source_id", name: "crm_phonecall_source_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall2phonecall", "crm_team", column: "team_id", name: "crm_phonecall2phonecall_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall2phonecall", "res_partner", column: "partner_id", name: "crm_phonecall2phonecall_partner_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall2phonecall", "res_users", column: "create_uid", name: "crm_phonecall2phonecall_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall2phonecall", "res_users", column: "user_id", name: "crm_phonecall2phonecall_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall2phonecall", "res_users", column: "write_uid", name: "crm_phonecall2phonecall_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_phonecall_tag_rel", "crm_lead_tag", column: "tag_id", name: "crm_phonecall_tag_rel_tag_id_fkey", on_delete: :cascade
  add_foreign_key "crm_phonecall_tag_rel", "crm_phonecall", column: "phone_id", name: "crm_phonecall_tag_rel_phone_id_fkey", on_delete: :cascade
  add_foreign_key "crm_stage", "crm_team", column: "team_id", name: "crm_stage_team_id_fkey", on_delete: :nullify
  add_foreign_key "crm_stage", "res_users", column: "create_uid", name: "crm_stage_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_stage", "res_users", column: "write_uid", name: "crm_stage_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_team", "mail_alias", column: "alias_id", name: "crm_team_alias_id_fkey", on_delete: :restrict
  add_foreign_key "crm_team", "res_company", column: "company_id", name: "crm_team_company_id_fkey", on_delete: :nullify
  add_foreign_key "crm_team", "res_users", column: "create_uid", name: "crm_team_create_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_team", "res_users", column: "marketing_user_id", name: "crm_team_marketing_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_team", "res_users", column: "user_id", name: "crm_team_user_id_fkey", on_delete: :nullify
  add_foreign_key "crm_team", "res_users", column: "write_uid", name: "crm_team_write_uid_fkey", on_delete: :nullify
  add_foreign_key "crm_team_claim_stage_rel", "crm_claim_stage", column: "stage_id", name: "crm_team_claim_stage_rel_stage_id_fkey", on_delete: :cascade
  add_foreign_key "crm_team_claim_stage_rel", "crm_team", column: "team_id", name: "crm_team_claim_stage_rel_team_id_fkey", on_delete: :cascade
  add_foreign_key "decimal_precision", "res_users", column: "create_uid", name: "decimal_precision_create_uid_fkey", on_delete: :nullify
  add_foreign_key "decimal_precision", "res_users", column: "write_uid", name: "decimal_precision_write_uid_fkey", on_delete: :nullify
  add_foreign_key "decimal_precision_test", "res_users", column: "create_uid", name: "decimal_precision_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "decimal_precision_test", "res_users", column: "write_uid", name: "decimal_precision_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page", "document_page", column: "parent_id", name: "document_page_parent_id_fkey", on_delete: :nullify
  add_foreign_key "document_page", "document_page_history", column: "history_head", name: "document_page_history_head_fkey", on_delete: :nullify
  add_foreign_key "document_page", "ir_ui_menu", column: "menu_id", name: "document_page_menu_id_fkey", on_delete: :nullify
  add_foreign_key "document_page", "res_company", column: "company_id", name: "document_page_company_id_fkey", on_delete: :cascade
  add_foreign_key "document_page", "res_groups", column: "approver_gid", name: "document_page_approver_gid_fkey", on_delete: :nullify
  add_foreign_key "document_page", "res_users", column: "approved_uid", name: "document_page_approved_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page", "res_users", column: "content_uid", name: "document_page_content_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page", "res_users", column: "create_uid", name: "document_page_create_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page", "res_users", column: "write_uid", name: "document_page_write_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page_create_menu", "ir_ui_menu", column: "menu_parent_id", name: "document_page_create_menu_menu_parent_id_fkey", on_delete: :nullify
  add_foreign_key "document_page_create_menu", "res_users", column: "create_uid", name: "document_page_create_menu_create_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page_create_menu", "res_users", column: "write_uid", name: "document_page_create_menu_write_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page_history", "document_page", column: "page_id", name: "document_page_history_page_id_fkey", on_delete: :cascade
  add_foreign_key "document_page_history", "res_company", column: "company_id", name: "document_page_history_company_id_fkey", on_delete: :nullify
  add_foreign_key "document_page_history", "res_users", column: "approved_uid", name: "document_page_history_approved_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page_history", "res_users", column: "create_uid", name: "document_page_history_create_uid_fkey", on_delete: :nullify
  add_foreign_key "document_page_history", "res_users", column: "write_uid", name: "document_page_history_write_uid_fkey", on_delete: :nullify
  add_foreign_key "email_template_attachment_rel", "ir_attachment", column: "attachment_id", name: "email_template_attachment_rel_attachment_id_fkey", on_delete: :cascade
  add_foreign_key "email_template_attachment_rel", "mail_template", column: "email_template_id", name: "email_template_attachment_rel_email_template_id_fkey", on_delete: :cascade
  add_foreign_key "email_template_preview", "ir_act_report_xml", column: "report_template", name: "email_template_preview_report_template_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview", "ir_act_window", column: "ref_ir_act_window", name: "email_template_preview_ref_ir_act_window_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview", "ir_mail_server", column: "mail_server_id", name: "email_template_preview_mail_server_id_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview", "ir_model", column: "model_id", name: "email_template_preview_model_id_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview", "ir_model", column: "sub_object", name: "email_template_preview_sub_object_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview", "ir_model_fields", column: "model_object_field", name: "email_template_preview_model_object_field_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview", "ir_model_fields", column: "sub_model_object_field", name: "email_template_preview_sub_model_object_field_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview", "res_users", column: "create_uid", name: "email_template_preview_create_uid_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview", "res_users", column: "write_uid", name: "email_template_preview_write_uid_fkey", on_delete: :nullify
  add_foreign_key "email_template_preview_res_partner_rel", "email_template_preview", name: "email_template_preview_res_partn_email_template_preview_id_fkey", on_delete: :cascade
  add_foreign_key "email_template_preview_res_partner_rel", "res_partner", name: "email_template_preview_res_partner_rel_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "employee_category_rel", "hr_employee", column: "emp_id", name: "employee_category_rel_emp_id_fkey", on_delete: :cascade
  add_foreign_key "employee_category_rel", "hr_employee_category", column: "category_id", name: "employee_category_rel_category_id_fkey", on_delete: :cascade
  add_foreign_key "equipment_tag_rel", "maintenance_equipment", column: "equipment_id", name: "equipment_tag_rel_equipment_id_fkey", on_delete: :cascade
  add_foreign_key "equipment_tag_rel", "maintenance_equipment_tag", column: "tag_id", name: "equipment_tag_rel_tag_id_fkey", on_delete: :cascade
  add_foreign_key "event_allowed_track_tags_rel", "event_event", name: "event_allowed_track_tags_rel_event_event_id_fkey", on_delete: :cascade
  add_foreign_key "event_allowed_track_tags_rel", "event_track_tag", name: "event_allowed_track_tags_rel_event_track_tag_id_fkey", on_delete: :cascade
  add_foreign_key "event_answer", "event_question", column: "question_id", name: "event_answer_question_id_fkey", on_delete: :cascade
  add_foreign_key "event_answer", "res_users", column: "create_uid", name: "event_answer_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_answer", "res_users", column: "write_uid", name: "event_answer_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_confirm", "res_users", column: "create_uid", name: "event_confirm_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_confirm", "res_users", column: "write_uid", name: "event_confirm_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_event", "event_type", name: "event_event_event_type_id_fkey", on_delete: :nullify
  add_foreign_key "event_event", "res_company", column: "company_id", name: "event_event_company_id_fkey", on_delete: :nullify
  add_foreign_key "event_event", "res_country", column: "country_id", name: "event_event_country_id_fkey", on_delete: :nullify
  add_foreign_key "event_event", "res_partner", column: "address_id", name: "event_event_address_id_fkey", on_delete: :nullify
  add_foreign_key "event_event", "res_partner", column: "organizer_id", name: "event_event_organizer_id_fkey", on_delete: :nullify
  add_foreign_key "event_event", "res_users", column: "create_uid", name: "event_event_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_event", "res_users", column: "user_id", name: "event_event_user_id_fkey", on_delete: :nullify
  add_foreign_key "event_event", "res_users", column: "write_uid", name: "event_event_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_event", "website_menu", column: "menu_id", name: "event_event_menu_id_fkey", on_delete: :nullify
  add_foreign_key "event_lead", "event_event", column: "event_id", name: "event_lead_event_id_fkey", on_delete: :nullify
  add_foreign_key "event_lead", "res_users", column: "create_uid", name: "event_lead_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_lead", "res_users", column: "write_uid", name: "event_lead_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_mail", "event_event", column: "event_id", name: "event_mail_event_id_fkey", on_delete: :cascade
  add_foreign_key "event_mail", "mail_template", column: "template_id", name: "event_mail_template_id_fkey", on_delete: :restrict
  add_foreign_key "event_mail", "res_users", column: "create_uid", name: "event_mail_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_mail", "res_users", column: "write_uid", name: "event_mail_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_mail_registration", "event_mail", column: "scheduler_id", name: "event_mail_registration_scheduler_id_fkey", on_delete: :cascade
  add_foreign_key "event_mail_registration", "event_registration", column: "registration_id", name: "event_mail_registration_registration_id_fkey", on_delete: :cascade
  add_foreign_key "event_mail_registration", "res_users", column: "create_uid", name: "event_mail_registration_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_mail_registration", "res_users", column: "write_uid", name: "event_mail_registration_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_question", "event_event", column: "event_id", name: "event_question_event_id_fkey", on_delete: :cascade
  add_foreign_key "event_question", "event_type", name: "event_question_event_type_id_fkey", on_delete: :cascade
  add_foreign_key "event_question", "res_users", column: "create_uid", name: "event_question_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_question", "res_users", column: "write_uid", name: "event_question_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_registration", "event_event", column: "event_id", name: "event_registration_event_id_fkey", on_delete: :nullify
  add_foreign_key "event_registration", "event_type", name: "event_registration_event_type_id_fkey", on_delete: :nullify
  add_foreign_key "event_registration", "res_company", column: "company_id", name: "event_registration_company_id_fkey", on_delete: :nullify
  add_foreign_key "event_registration", "res_partner", column: "partner_id", name: "event_registration_partner_id_fkey", on_delete: :nullify
  add_foreign_key "event_registration", "res_users", column: "create_uid", name: "event_registration_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_registration", "res_users", column: "user_id", name: "event_registration_user_id_fkey", on_delete: :nullify
  add_foreign_key "event_registration", "res_users", column: "write_uid", name: "event_registration_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_registration_answer", "event_answer", name: "event_registration_answer_event_answer_id_fkey", on_delete: :cascade
  add_foreign_key "event_registration_answer", "event_registration", name: "event_registration_answer_event_registration_id_fkey", on_delete: :cascade
  add_foreign_key "event_registration_answer", "res_users", column: "create_uid", name: "event_registration_answer_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_registration_answer", "res_users", column: "write_uid", name: "event_registration_answer_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_sponsor", "event_event", column: "event_id", name: "event_sponsor_event_id_fkey", on_delete: :nullify
  add_foreign_key "event_sponsor", "event_sponsor_type", column: "sponsor_type_id", name: "event_sponsor_sponsor_type_id_fkey", on_delete: :nullify
  add_foreign_key "event_sponsor", "res_partner", column: "partner_id", name: "event_sponsor_partner_id_fkey", on_delete: :nullify
  add_foreign_key "event_sponsor", "res_users", column: "create_uid", name: "event_sponsor_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_sponsor", "res_users", column: "write_uid", name: "event_sponsor_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_sponsor_type", "res_users", column: "create_uid", name: "event_sponsor_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_sponsor_type", "res_users", column: "write_uid", name: "event_sponsor_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track", "event_event", column: "event_id", name: "event_track_event_id_fkey", on_delete: :nullify
  add_foreign_key "event_track", "event_track_location", column: "location_id", name: "event_track_location_id_fkey", on_delete: :nullify
  add_foreign_key "event_track", "event_track_stage", column: "stage_id", name: "event_track_stage_id_fkey", on_delete: :nullify
  add_foreign_key "event_track", "res_partner", column: "partner_id", name: "event_track_partner_id_fkey", on_delete: :nullify
  add_foreign_key "event_track", "res_users", column: "create_uid", name: "event_track_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track", "res_users", column: "user_id", name: "event_track_user_id_fkey", on_delete: :nullify
  add_foreign_key "event_track", "res_users", column: "write_uid", name: "event_track_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track_event_track_tag_rel", "event_track", name: "event_track_event_track_tag_rel_event_track_id_fkey", on_delete: :cascade
  add_foreign_key "event_track_event_track_tag_rel", "event_track_tag", name: "event_track_event_track_tag_rel_event_track_tag_id_fkey", on_delete: :cascade
  add_foreign_key "event_track_location", "res_users", column: "create_uid", name: "event_track_location_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track_location", "res_users", column: "write_uid", name: "event_track_location_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track_stage", "mail_template", name: "event_track_stage_mail_template_id_fkey", on_delete: :nullify
  add_foreign_key "event_track_stage", "res_users", column: "create_uid", name: "event_track_stage_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track_stage", "res_users", column: "write_uid", name: "event_track_stage_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track_tag", "res_users", column: "create_uid", name: "event_track_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track_tag", "res_users", column: "write_uid", name: "event_track_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_track_tags_rel", "event_event", name: "event_track_tags_rel_event_event_id_fkey", on_delete: :cascade
  add_foreign_key "event_track_tags_rel", "event_track_tag", name: "event_track_tags_rel_event_track_tag_id_fkey", on_delete: :cascade
  add_foreign_key "event_type", "res_users", column: "create_uid", name: "event_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_type", "res_users", column: "write_uid", name: "event_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "event_type_mail", "event_type", name: "event_type_mail_event_type_id_fkey", on_delete: :cascade
  add_foreign_key "event_type_mail", "mail_template", column: "template_id", name: "event_type_mail_template_id_fkey", on_delete: :restrict
  add_foreign_key "event_type_mail", "res_users", column: "create_uid", name: "event_type_mail_create_uid_fkey", on_delete: :nullify
  add_foreign_key "event_type_mail", "res_users", column: "write_uid", name: "event_type_mail_write_uid_fkey", on_delete: :nullify
  add_foreign_key "expense_tax", "account_tax", column: "tax_id", name: "expense_tax_tax_id_fkey", on_delete: :cascade
  add_foreign_key "expense_tax", "hr_expense", column: "expense_id", name: "expense_tax_expense_id_fkey", on_delete: :cascade
  add_foreign_key "export_attendance", "hr_year", column: "year_id", name: "export_attendance_year_id_fkey", on_delete: :nullify
  add_foreign_key "export_attendance", "res_users", column: "create_uid", name: "export_attendance_create_uid_fkey", on_delete: :nullify
  add_foreign_key "export_attendance", "res_users", column: "write_uid", name: "export_attendance_write_uid_fkey", on_delete: :nullify
  add_foreign_key "fees_detail_report_wizard", "op_course", column: "course_id", name: "fees_detail_report_wizard_course_id_fkey", on_delete: :nullify
  add_foreign_key "fees_detail_report_wizard", "op_student", column: "student_id", name: "fees_detail_report_wizard_student_id_fkey", on_delete: :nullify
  add_foreign_key "fees_detail_report_wizard", "res_users", column: "create_uid", name: "fees_detail_report_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "fees_detail_report_wizard", "res_users", column: "write_uid", name: "fees_detail_report_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "fetchmail_server", "ir_act_server", column: "action_id", name: "fetchmail_server_action_id_fkey", on_delete: :nullify
  add_foreign_key "fetchmail_server", "ir_model", column: "object_id", name: "fetchmail_server_object_id_fkey", on_delete: :nullify
  add_foreign_key "fetchmail_server", "res_users", column: "create_uid", name: "fetchmail_server_create_uid_fkey", on_delete: :nullify
  add_foreign_key "fetchmail_server", "res_users", column: "write_uid", name: "fetchmail_server_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge", "res_users", column: "create_uid", name: "gamification_badge_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge", "res_users", column: "write_uid", name: "gamification_badge_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_rule_badge_rel", "gamification_badge", column: "badge1_id", name: "gamification_badge_rule_badge_rel_badge1_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_badge_rule_badge_rel", "gamification_badge", column: "badge2_id", name: "gamification_badge_rule_badge_rel_badge2_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_badge_user", "gamification_badge", column: "badge_id", name: "gamification_badge_user_badge_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_badge_user", "gamification_challenge", column: "challenge_id", name: "gamification_badge_user_challenge_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user", "hr_employee", column: "employee_id", name: "gamification_badge_user_employee_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user", "res_users", column: "create_uid", name: "gamification_badge_user_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user", "res_users", column: "sender_id", name: "gamification_badge_user_sender_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user", "res_users", column: "user_id", name: "gamification_badge_user_user_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_badge_user", "res_users", column: "write_uid", name: "gamification_badge_user_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user_wizard", "gamification_badge", column: "badge_id", name: "gamification_badge_user_wizard_badge_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user_wizard", "hr_employee", column: "employee_id", name: "gamification_badge_user_wizard_employee_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user_wizard", "res_users", column: "create_uid", name: "gamification_badge_user_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user_wizard", "res_users", column: "user_id", name: "gamification_badge_user_wizard_user_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_badge_user_wizard", "res_users", column: "write_uid", name: "gamification_badge_user_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "gamification_badge", column: "reward_first_id", name: "gamification_challenge_reward_first_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "gamification_badge", column: "reward_id", name: "gamification_challenge_reward_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "gamification_badge", column: "reward_second_id", name: "gamification_challenge_reward_second_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "gamification_badge", column: "reward_third_id", name: "gamification_challenge_reward_third_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "mail_channel", column: "report_message_group_id", name: "gamification_challenge_report_message_group_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "mail_template", column: "report_template_id", name: "gamification_challenge_report_template_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "res_users", column: "create_uid", name: "gamification_challenge_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "res_users", column: "manager_id", name: "gamification_challenge_manager_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge", "res_users", column: "write_uid", name: "gamification_challenge_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge_line", "gamification_challenge", column: "challenge_id", name: "gamification_challenge_line_challenge_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_challenge_line", "gamification_goal_definition", column: "definition_id", name: "gamification_challenge_line_definition_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_challenge_line", "res_users", column: "create_uid", name: "gamification_challenge_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge_line", "res_users", column: "write_uid", name: "gamification_challenge_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_challenge_users_rel", "gamification_challenge", name: "gamification_challenge_users_rel_gamification_challenge_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_challenge_users_rel", "res_users", column: "res_users_id", name: "gamification_challenge_users_rel_res_users_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_goal", "gamification_challenge", column: "challenge_id", name: "gamification_goal_challenge_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal", "gamification_challenge_line", column: "line_id", name: "gamification_goal_line_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_goal", "gamification_goal_definition", column: "definition_id", name: "gamification_goal_definition_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_goal", "res_users", column: "create_uid", name: "gamification_goal_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal", "res_users", column: "user_id", name: "gamification_goal_user_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_goal", "res_users", column: "write_uid", name: "gamification_goal_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_definition", "ir_act_window", column: "action_id", name: "gamification_goal_definition_action_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_definition", "ir_model", column: "model_id", name: "gamification_goal_definition_model_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_definition", "ir_model_fields", column: "batch_distinctive_field", name: "gamification_goal_definition_batch_distinctive_field_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_definition", "ir_model_fields", column: "field_date_id", name: "gamification_goal_definition_field_date_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_definition", "ir_model_fields", column: "field_id", name: "gamification_goal_definition_field_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_definition", "res_users", column: "create_uid", name: "gamification_goal_definition_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_definition", "res_users", column: "write_uid", name: "gamification_goal_definition_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_wizard", "gamification_goal", column: "goal_id", name: "gamification_goal_wizard_goal_id_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_wizard", "res_users", column: "create_uid", name: "gamification_goal_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_goal_wizard", "res_users", column: "write_uid", name: "gamification_goal_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "gamification_invited_user_ids_rel", "gamification_challenge", name: "gamification_invited_user_ids_re_gamification_challenge_id_fkey", on_delete: :cascade
  add_foreign_key "gamification_invited_user_ids_rel", "res_users", column: "res_users_id", name: "gamification_invited_user_ids_rel_res_users_id_fkey", on_delete: :cascade
  add_foreign_key "gen_time_table_line", "generate_time_table", column: "gen_time_table", name: "gen_time_table_line_gen_time_table_fkey", on_delete: :nullify
  add_foreign_key "gen_time_table_line", "op_classroom", column: "classroom_id", name: "gen_time_table_line_classroom_id_fkey", on_delete: :nullify
  add_foreign_key "gen_time_table_line", "op_faculty", column: "faculty_id", name: "gen_time_table_line_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "gen_time_table_line", "op_subject", column: "subject_id", name: "gen_time_table_line_subject_id_fkey", on_delete: :nullify
  add_foreign_key "gen_time_table_line", "op_timing", column: "timing_id", name: "gen_time_table_line_timing_id_fkey", on_delete: :nullify
  add_foreign_key "gen_time_table_line", "res_users", column: "create_uid", name: "gen_time_table_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "gen_time_table_line", "res_users", column: "write_uid", name: "gen_time_table_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "generate_time_table", "op_batch", column: "batch_id", name: "generate_time_table_batch_id_fkey", on_delete: :nullify
  add_foreign_key "generate_time_table", "op_course", column: "course_id", name: "generate_time_table_course_id_fkey", on_delete: :nullify
  add_foreign_key "generate_time_table", "op_subject", column: "subject_id", name: "generate_time_table_subject_id_fkey", on_delete: :nullify
  add_foreign_key "generate_time_table", "res_users", column: "create_uid", name: "generate_time_table_create_uid_fkey", on_delete: :nullify
  add_foreign_key "generate_time_table", "res_users", column: "write_uid", name: "generate_time_table_write_uid_fkey", on_delete: :nullify
  add_foreign_key "google_drive_config", "ir_filters", column: "filter_id", name: "google_drive_config_filter_id_fkey", on_delete: :nullify
  add_foreign_key "google_drive_config", "ir_model", column: "model_id", name: "google_drive_config_model_id_fkey", on_delete: :nullify
  add_foreign_key "google_drive_config", "res_users", column: "create_uid", name: "google_drive_config_create_uid_fkey", on_delete: :nullify
  add_foreign_key "google_drive_config", "res_users", column: "write_uid", name: "google_drive_config_write_uid_fkey", on_delete: :nullify
  add_foreign_key "google_service", "res_users", column: "create_uid", name: "google_service_create_uid_fkey", on_delete: :nullify
  add_foreign_key "google_service", "res_users", column: "write_uid", name: "google_service_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "hr_department", column: "department_id", name: "hr_applicant_department_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "hr_employee", column: "emp_id", name: "hr_applicant_emp_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "hr_job", column: "job_id", name: "hr_applicant_job_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "hr_recruitment_degree", column: "type_id", name: "hr_applicant_type_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "hr_recruitment_source", column: "applicant_source_id", name: "hr_applicant_applicant_source_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "hr_recruitment_stage", column: "last_stage_id", name: "hr_applicant_last_stage_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "hr_recruitment_stage", column: "stage_id", name: "hr_applicant_stage_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "incomming_mail", column: "incomming_email_id", name: "hr_applicant_incomming_email_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "recruitment_source", column: "source_applicant_id", name: "hr_applicant_source_applicant_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "res_company", column: "company_id", name: "hr_applicant_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "res_partner", column: "partner_id", name: "hr_applicant_partner_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "res_users", column: "create_uid", name: "hr_applicant_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "res_users", column: "user_id", name: "hr_applicant_user_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "res_users", column: "write_uid", name: "hr_applicant_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "utm_campaign", column: "campaign_id", name: "hr_applicant_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "utm_medium", column: "medium_id", name: "hr_applicant_medium_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant", "utm_source", column: "source_id", name: "hr_applicant_source_id_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant_category", "res_users", column: "create_uid", name: "hr_applicant_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant_category", "res_users", column: "write_uid", name: "hr_applicant_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_applicant_hr_applicant_category_rel", "hr_applicant", name: "hr_applicant_hr_applicant_category_rel_hr_applicant_id_fkey", on_delete: :cascade
  add_foreign_key "hr_applicant_hr_applicant_category_rel", "hr_applicant_category", name: "hr_applicant_hr_applicant_categor_hr_applicant_category_id_fkey", on_delete: :cascade
  add_foreign_key "hr_attendance", "hr_employee", column: "employee_id", name: "hr_attendance_employee_id_fkey", on_delete: :cascade
  add_foreign_key "hr_attendance", "hr_holidays", column: "holiday_id", name: "hr_attendance_holiday_id_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance", "res_company", column: "company_id", name: "hr_attendance_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance", "res_users", column: "create_uid", name: "hr_attendance_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance", "res_users", column: "write_uid", name: "hr_attendance_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_addition", "hr_department", column: "department_id", name: "hr_attendance_addition_department_id_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_addition", "hr_employee", column: "employee_id", name: "hr_attendance_addition_employee_id_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_addition", "hr_holidays_status", column: "type", name: "hr_attendance_addition_type_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_addition", "res_users", column: "create_uid", name: "hr_attendance_addition_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_addition", "res_users", column: "write_uid", name: "hr_attendance_addition_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_import", "ir_attachment", column: "attachment_id", name: "hr_attendance_import_attachment_id_fkey", on_delete: :cascade
  add_foreign_key "hr_attendance_import", "res_users", column: "create_uid", name: "hr_attendance_import_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_import", "res_users", column: "write_uid", name: "hr_attendance_import_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_report", "res_company", column: "company_id", name: "hr_attendance_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_report", "res_users", column: "create_uid", name: "hr_attendance_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_attendance_report", "res_users", column: "write_uid", name: "hr_attendance_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "hr_contract_type", column: "type_id", name: "hr_contract_type_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "hr_department", column: "department_id", name: "hr_contract_department_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "hr_employee", column: "employee_id", name: "hr_contract_employee_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "hr_job", column: "job_id", name: "hr_contract_job_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "hr_payroll_structure", column: "struct_id", name: "hr_contract_struct_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "res_company", column: "company_id", name: "hr_contract_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "res_users", column: "create_uid", name: "hr_contract_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "res_users", column: "write_uid", name: "hr_contract_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_contract", "resource_calendar", name: "hr_contract_resource_calendar_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contract_advantage_template", "res_users", column: "create_uid", name: "hr_contract_advantage_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_contract_advantage_template", "res_users", column: "write_uid", name: "hr_contract_advantage_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_contract_type", "res_users", column: "create_uid", name: "hr_contract_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_contract_type", "res_users", column: "write_uid", name: "hr_contract_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_contribution_register", "res_company", column: "company_id", name: "hr_contribution_register_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contribution_register", "res_partner", column: "partner_id", name: "hr_contribution_register_partner_id_fkey", on_delete: :nullify
  add_foreign_key "hr_contribution_register", "res_users", column: "create_uid", name: "hr_contribution_register_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_contribution_register", "res_users", column: "write_uid", name: "hr_contribution_register_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_department", "hr_department", column: "parent_id", name: "hr_department_parent_id_fkey", on_delete: :nullify
  add_foreign_key "hr_department", "hr_employee", column: "manager_id", name: "hr_department_manager_id_fkey", on_delete: :nullify
  add_foreign_key "hr_department", "res_company", column: "company_id", name: "hr_department_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_department", "res_users", column: "create_uid", name: "hr_department_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_department", "res_users", column: "write_uid", name: "hr_department_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "hr_contract", column: "contract_id", name: "hr_employee_contract_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "hr_department", column: "department_id", name: "hr_employee_department_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "hr_employee", column: "coach_id", name: "hr_employee_coach_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "hr_employee", column: "parent_id", name: "hr_employee_parent_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "hr_employee", column: "presenter_employee", name: "hr_employee_presenter_employee_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "hr_job", column: "job_id", name: "hr_employee_job_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "res_company", column: "company_id", name: "hr_employee_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "res_country", column: "country_id", name: "hr_employee_country_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "res_partner", column: "address_home_id", name: "hr_employee_address_home_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "res_partner", column: "address_id", name: "hr_employee_address_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "res_partner_bank", column: "bank_account_id", name: "hr_employee_bank_account_id_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "res_users", column: "create_uid", name: "hr_employee_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "res_users", column: "write_uid", name: "hr_employee_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_employee", "resource_resource", column: "resource_id", name: "hr_employee_resource_id_fkey", on_delete: :restrict
  add_foreign_key "hr_employee_category", "res_users", column: "create_uid", name: "hr_employee_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_employee_category", "res_users", column: "write_uid", name: "hr_employee_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_employee_group_rel", "hr_employee", column: "employee_id", name: "hr_employee_group_rel_employee_id_fkey", on_delete: :cascade
  add_foreign_key "hr_employee_group_rel", "hr_payslip_employees", column: "payslip_id", name: "hr_employee_group_rel_payslip_id_fkey", on_delete: :cascade
  add_foreign_key "hr_expense", "account_account", column: "account_id", name: "hr_expense_account_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "account_analytic_account", column: "analytic_account_id", name: "hr_expense_analytic_account_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "crm_claim", column: "claim_id", name: "hr_expense_claim_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "hr_employee", column: "employee_id", name: "hr_expense_employee_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "hr_employee", column: "manager_id", name: "hr_expense_manager_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "hr_expense_sheet", column: "sheet_id", name: "hr_expense_sheet_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "product_product", column: "product_id", name: "hr_expense_product_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "product_uom", name: "hr_expense_product_uom_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "res_company", column: "company_id", name: "hr_expense_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "res_currency", column: "currency_id", name: "hr_expense_currency_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "res_users", column: "create_uid", name: "hr_expense_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "res_users", column: "write_uid", name: "hr_expense_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_expense", "sale_order", name: "hr_expense_sale_order_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_hr_expense_refuse_wizard_rel", "hr_expense", name: "hr_expense_hr_expense_refuse_wizard_rel_hr_expense_id_fkey", on_delete: :cascade
  add_foreign_key "hr_expense_hr_expense_refuse_wizard_rel", "hr_expense_refuse_wizard", name: "hr_expense_hr_expense_refuse_w_hr_expense_refuse_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "hr_expense_refuse_wizard", "hr_expense_sheet", name: "hr_expense_refuse_wizard_hr_expense_sheet_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_refuse_wizard", "res_users", column: "create_uid", name: "hr_expense_refuse_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_refuse_wizard", "res_users", column: "write_uid", name: "hr_expense_refuse_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "account_journal", column: "bank_journal_id", name: "hr_expense_sheet_bank_journal_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "account_journal", column: "journal_id", name: "hr_expense_sheet_journal_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "account_move", name: "hr_expense_sheet_account_move_id_fkey", on_delete: :restrict
  add_foreign_key "hr_expense_sheet", "hr_department", column: "department_id", name: "hr_expense_sheet_department_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "hr_employee", column: "employee_id", name: "hr_expense_sheet_employee_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "res_company", column: "company_id", name: "hr_expense_sheet_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "res_currency", column: "currency_id", name: "hr_expense_sheet_currency_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "res_partner", column: "address_id", name: "hr_expense_sheet_address_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "res_users", column: "create_uid", name: "hr_expense_sheet_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "res_users", column: "responsible_id", name: "hr_expense_sheet_responsible_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet", "res_users", column: "write_uid", name: "hr_expense_sheet_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet_register_payment_wizard", "account_journal", column: "journal_id", name: "hr_expense_sheet_register_payment_wizard_journal_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet_register_payment_wizard", "account_payment_method", column: "payment_method_id", name: "hr_expense_sheet_register_payment_wizard_payment_method_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet_register_payment_wizard", "res_currency", column: "currency_id", name: "hr_expense_sheet_register_payment_wizard_currency_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet_register_payment_wizard", "res_partner", column: "partner_id", name: "hr_expense_sheet_register_payment_wizard_partner_id_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet_register_payment_wizard", "res_users", column: "create_uid", name: "hr_expense_sheet_register_payment_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_expense_sheet_register_payment_wizard", "res_users", column: "write_uid", name: "hr_expense_sheet_register_payment_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "calendar_event", column: "meeting_id", name: "hr_holidays_meeting_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "hr_department", column: "department_id", name: "hr_holidays_department_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "hr_employee", column: "employee_id", name: "hr_holidays_employee_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "hr_employee", column: "first_approver_id", name: "hr_holidays_first_approver_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "hr_employee", column: "manager_id", name: "hr_holidays_manager_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "hr_employee", column: "second_approver_id", name: "hr_holidays_second_approver_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "hr_employee_category", column: "category_id", name: "hr_holidays_category_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "hr_holidays", column: "parent_id", name: "hr_holidays_parent_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "hr_holidays_status", column: "holiday_status_id", name: "hr_holidays_holiday_status_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "res_company", column: "company_id", name: "hr_holidays_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "res_users", column: "create_uid", name: "hr_holidays_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "res_users", column: "user_id", name: "hr_holidays_user_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays", "res_users", column: "write_uid", name: "hr_holidays_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_status", "calendar_event_type", column: "categ_id", name: "hr_holidays_status_categ_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_status", "project_project", column: "timesheet_project_id", name: "hr_holidays_status_timesheet_project_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_status", "project_task", column: "timesheet_task_id", name: "hr_holidays_status_timesheet_task_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_status", "res_company", column: "company_id", name: "hr_holidays_status_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_status", "res_users", column: "create_uid", name: "hr_holidays_status_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_status", "res_users", column: "write_uid", name: "hr_holidays_status_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_summary_dept", "res_users", column: "create_uid", name: "hr_holidays_summary_dept_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_summary_dept", "res_users", column: "write_uid", name: "hr_holidays_summary_dept_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_summary_employee", "res_users", column: "create_uid", name: "hr_holidays_summary_employee_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_holidays_summary_employee", "res_users", column: "write_uid", name: "hr_holidays_summary_employee_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_job", "hr_department", column: "department_id", name: "hr_job_department_id_fkey", on_delete: :nullify
  add_foreign_key "hr_job", "hr_employee", column: "manager_id", name: "hr_job_manager_id_fkey", on_delete: :nullify
  add_foreign_key "hr_job", "mail_alias", column: "alias_id", name: "hr_job_alias_id_fkey", on_delete: :restrict
  add_foreign_key "hr_job", "res_company", column: "company_id", name: "hr_job_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_job", "res_partner", column: "address_id", name: "hr_job_address_id_fkey", on_delete: :nullify
  add_foreign_key "hr_job", "res_users", column: "create_uid", name: "hr_job_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_job", "res_users", column: "hr_responsible_id", name: "hr_job_hr_responsible_id_fkey", on_delete: :nullify
  add_foreign_key "hr_job", "res_users", column: "user_id", name: "hr_job_user_id_fkey", on_delete: :nullify
  add_foreign_key "hr_job", "res_users", column: "write_uid", name: "hr_job_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payroll_structure", "hr_payroll_structure", column: "parent_id", name: "hr_payroll_structure_parent_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payroll_structure", "res_company", column: "company_id", name: "hr_payroll_structure_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payroll_structure", "res_users", column: "create_uid", name: "hr_payroll_structure_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payroll_structure", "res_users", column: "write_uid", name: "hr_payroll_structure_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip", "hr_contract", column: "contract_id", name: "hr_payslip_contract_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip", "hr_employee", column: "employee_id", name: "hr_payslip_employee_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip", "hr_payroll_structure", column: "struct_id", name: "hr_payslip_struct_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip", "hr_payslip_run", column: "payslip_run_id", name: "hr_payslip_payslip_run_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip", "res_company", column: "company_id", name: "hr_payslip_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip", "res_users", column: "create_uid", name: "hr_payslip_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip", "res_users", column: "write_uid", name: "hr_payslip_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_employees", "res_users", column: "create_uid", name: "hr_payslip_employees_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_employees", "res_users", column: "write_uid", name: "hr_payslip_employees_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_input", "hr_contract", column: "contract_id", name: "hr_payslip_input_contract_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_input", "hr_payslip", column: "payslip_id", name: "hr_payslip_input_payslip_id_fkey", on_delete: :cascade
  add_foreign_key "hr_payslip_input", "res_users", column: "create_uid", name: "hr_payslip_input_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_input", "res_users", column: "write_uid", name: "hr_payslip_input_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "hr_contract", column: "contract_id", name: "hr_payslip_line_contract_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "hr_contribution_register", column: "register_id", name: "hr_payslip_line_register_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "hr_employee", column: "employee_id", name: "hr_payslip_line_employee_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "hr_payslip", column: "slip_id", name: "hr_payslip_line_slip_id_fkey", on_delete: :cascade
  add_foreign_key "hr_payslip_line", "hr_salary_rule", column: "parent_rule_id", name: "hr_payslip_line_parent_rule_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "hr_salary_rule", column: "salary_rule_id", name: "hr_payslip_line_salary_rule_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "hr_salary_rule_category", column: "category_id", name: "hr_payslip_line_category_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "res_company", column: "company_id", name: "hr_payslip_line_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "res_users", column: "create_uid", name: "hr_payslip_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_line", "res_users", column: "write_uid", name: "hr_payslip_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_run", "res_users", column: "create_uid", name: "hr_payslip_run_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_run", "res_users", column: "write_uid", name: "hr_payslip_run_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_worked_days", "hr_contract", column: "contract_id", name: "hr_payslip_worked_days_contract_id_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_worked_days", "hr_payslip", column: "payslip_id", name: "hr_payslip_worked_days_payslip_id_fkey", on_delete: :cascade
  add_foreign_key "hr_payslip_worked_days", "res_users", column: "create_uid", name: "hr_payslip_worked_days_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_payslip_worked_days", "res_users", column: "write_uid", name: "hr_payslip_worked_days_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_public_holiday", "res_company", column: "company_id", name: "hr_public_holiday_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_public_holiday", "res_users", column: "create_uid", name: "hr_public_holiday_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_public_holiday", "res_users", column: "write_uid", name: "hr_public_holiday_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_public_holiday_line", "hr_public_holiday", column: "holiday_id", name: "hr_public_holiday_line_holiday_id_fkey", on_delete: :nullify
  add_foreign_key "hr_public_holiday_line", "res_users", column: "create_uid", name: "hr_public_holiday_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_public_holiday_line", "res_users", column: "write_uid", name: "hr_public_holiday_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_degree", "res_users", column: "create_uid", name: "hr_recruitment_degree_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_degree", "res_users", column: "write_uid", name: "hr_recruitment_degree_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_source", "hr_job", column: "job_id", name: "hr_recruitment_source_job_id_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_source", "mail_alias", column: "alias_id", name: "hr_recruitment_source_alias_id_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_source", "res_users", column: "create_uid", name: "hr_recruitment_source_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_source", "res_users", column: "write_uid", name: "hr_recruitment_source_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_source", "utm_source", column: "source_id", name: "hr_recruitment_source_source_id_fkey", on_delete: :cascade
  add_foreign_key "hr_recruitment_stage", "hr_job", column: "job_id", name: "hr_recruitment_stage_job_id_fkey", on_delete: :cascade
  add_foreign_key "hr_recruitment_stage", "mail_template", column: "template_id", name: "hr_recruitment_stage_template_id_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_stage", "res_users", column: "create_uid", name: "hr_recruitment_stage_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_recruitment_stage", "res_users", column: "write_uid", name: "hr_recruitment_stage_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_rule_input", "hr_salary_rule", column: "input_id", name: "hr_rule_input_input_id_fkey", on_delete: :nullify
  add_foreign_key "hr_rule_input", "res_users", column: "create_uid", name: "hr_rule_input_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_rule_input", "res_users", column: "write_uid", name: "hr_rule_input_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule", "hr_contribution_register", column: "register_id", name: "hr_salary_rule_register_id_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule", "hr_salary_rule", column: "parent_rule_id", name: "hr_salary_rule_parent_rule_id_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule", "hr_salary_rule_category", column: "category_id", name: "hr_salary_rule_category_id_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule", "res_company", column: "company_id", name: "hr_salary_rule_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule", "res_users", column: "create_uid", name: "hr_salary_rule_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule", "res_users", column: "write_uid", name: "hr_salary_rule_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule_category", "hr_salary_rule_category", column: "parent_id", name: "hr_salary_rule_category_parent_id_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule_category", "res_company", column: "company_id", name: "hr_salary_rule_category_company_id_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule_category", "res_users", column: "create_uid", name: "hr_salary_rule_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_salary_rule_category", "res_users", column: "write_uid", name: "hr_salary_rule_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_structure_salary_rule_rel", "hr_payroll_structure", column: "struct_id", name: "hr_structure_salary_rule_rel_struct_id_fkey", on_delete: :cascade
  add_foreign_key "hr_structure_salary_rule_rel", "hr_salary_rule", column: "rule_id", name: "hr_structure_salary_rule_rel_rule_id_fkey", on_delete: :cascade
  add_foreign_key "hr_year", "res_users", column: "create_uid", name: "hr_year_create_uid_fkey", on_delete: :nullify
  add_foreign_key "hr_year", "res_users", column: "write_uid", name: "hr_year_write_uid_fkey", on_delete: :nullify
  add_foreign_key "iap_account", "res_company", column: "company_id", name: "iap_account_company_id_fkey", on_delete: :nullify
  add_foreign_key "iap_account", "res_users", column: "create_uid", name: "iap_account_create_uid_fkey", on_delete: :nullify
  add_foreign_key "iap_account", "res_users", column: "write_uid", name: "iap_account_write_uid_fkey", on_delete: :nullify
  add_foreign_key "im_livechat_channel", "res_users", column: "create_uid", name: "im_livechat_channel_create_uid_fkey", on_delete: :nullify
  add_foreign_key "im_livechat_channel", "res_users", column: "write_uid", name: "im_livechat_channel_write_uid_fkey", on_delete: :nullify
  add_foreign_key "im_livechat_channel_country_rel", "im_livechat_channel_rule", column: "channel_id", name: "im_livechat_channel_country_rel_channel_id_fkey", on_delete: :cascade
  add_foreign_key "im_livechat_channel_country_rel", "res_country", column: "country_id", name: "im_livechat_channel_country_rel_country_id_fkey", on_delete: :cascade
  add_foreign_key "im_livechat_channel_im_user", "im_livechat_channel", column: "channel_id", name: "im_livechat_channel_im_user_channel_id_fkey", on_delete: :cascade
  add_foreign_key "im_livechat_channel_im_user", "res_users", column: "user_id", name: "im_livechat_channel_im_user_user_id_fkey", on_delete: :cascade
  add_foreign_key "im_livechat_channel_rule", "im_livechat_channel", column: "channel_id", name: "im_livechat_channel_rule_channel_id_fkey", on_delete: :nullify
  add_foreign_key "im_livechat_channel_rule", "res_users", column: "create_uid", name: "im_livechat_channel_rule_create_uid_fkey", on_delete: :nullify
  add_foreign_key "im_livechat_channel_rule", "res_users", column: "write_uid", name: "im_livechat_channel_rule_write_uid_fkey", on_delete: :nullify
  add_foreign_key "incoming_mail_job_rel", "hr_job", column: "job_id", name: "incoming_mail_job_rel_job_id_fkey", on_delete: :cascade
  add_foreign_key "incoming_mail_job_rel", "incomming_mail", column: "mail_id", name: "incoming_mail_job_rel_mail_id_fkey", on_delete: :cascade
  add_foreign_key "incomming_mail", "hr_job", column: "job_id", name: "incomming_mail_job_id_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail", "incomming_mail_tag", column: "tag_id", name: "incomming_mail_tag_id_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail", "res_partner", column: "partner_id", name: "incomming_mail_partner_id_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail", "res_users", column: "create_uid", name: "incomming_mail_create_uid_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail", "res_users", column: "write_uid", name: "incomming_mail_write_uid_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail", "utm_campaign", column: "campaign_id", name: "incomming_mail_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail", "utm_medium", column: "medium_id", name: "incomming_mail_medium_id_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail", "utm_source", column: "source_id", name: "incomming_mail_source_id_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail_attachment_rel", "incomming_mail", column: "mail_id", name: "incomming_mail_attachment_rel_mail_id_fkey", on_delete: :cascade
  add_foreign_key "incomming_mail_attachment_rel", "ir_attachment", column: "attachment_id", name: "incomming_mail_attachment_rel_attachment_id_fkey", on_delete: :cascade
  add_foreign_key "incomming_mail_tag", "res_users", column: "create_uid", name: "incomming_mail_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "incomming_mail_tag", "res_users", column: "write_uid", name: "incomming_mail_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_client", "ir_model", column: "binding_model_id", name: "ir_act_client_binding_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_client", "res_users", column: "create_uid", name: "ir_act_client_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_client", "res_users", column: "write_uid", name: "ir_act_client_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_report_xml", "ir_model", column: "binding_model_id", name: "ir_act_report_xml_binding_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_report_xml", "report_paperformat", column: "paperformat_id", name: "ir_act_report_xml_paperformat_id_fkey", on_delete: :nullify
  add_foreign_key "ir_act_report_xml", "res_users", column: "create_uid", name: "ir_act_report_xml_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_report_xml", "res_users", column: "write_uid", name: "ir_act_report_xml_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_server", "ir_model", column: "binding_model_id", name: "ir_act_server_binding_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_server", "ir_model", column: "crud_model_id", name: "ir_act_server_crud_model_id_fkey", on_delete: :nullify
  add_foreign_key "ir_act_server", "ir_model", column: "model_id", name: "ir_act_server_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_server", "ir_model_fields", column: "link_field_id", name: "ir_act_server_link_field_id_fkey", on_delete: :nullify
  add_foreign_key "ir_act_server", "mail_template", column: "template_id", name: "ir_act_server_template_id_fkey", on_delete: :nullify
  add_foreign_key "ir_act_server", "res_users", column: "create_uid", name: "ir_act_server_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_server", "res_users", column: "write_uid", name: "ir_act_server_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_server_mail_channel_rel", "ir_act_server", name: "ir_act_server_mail_channel_rel_ir_act_server_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_server_mail_channel_rel", "mail_channel", name: "ir_act_server_mail_channel_rel_mail_channel_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_server_res_partner_rel", "ir_act_server", name: "ir_act_server_res_partner_rel_ir_act_server_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_server_res_partner_rel", "res_partner", name: "ir_act_server_res_partner_rel_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_url", "ir_model", column: "binding_model_id", name: "ir_act_url_binding_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_url", "res_users", column: "create_uid", name: "ir_act_url_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_url", "res_users", column: "write_uid", name: "ir_act_url_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_window", "ir_model", column: "binding_model_id", name: "ir_act_window_binding_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_window", "ir_ui_view", column: "search_view_id", name: "ir_act_window_search_view_id_fkey", on_delete: :nullify
  add_foreign_key "ir_act_window", "ir_ui_view", column: "view_id", name: "ir_act_window_view_id_fkey", on_delete: :nullify
  add_foreign_key "ir_act_window", "res_users", column: "create_uid", name: "ir_act_window_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_window", "res_users", column: "write_uid", name: "ir_act_window_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_window_group_rel", "ir_act_window", column: "act_id", name: "ir_act_window_group_rel_act_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_window_group_rel", "res_groups", column: "gid", name: "ir_act_window_group_rel_gid_fkey", on_delete: :cascade
  add_foreign_key "ir_act_window_view", "ir_act_window", column: "act_window_id", name: "ir_act_window_view_act_window_id_fkey", on_delete: :cascade
  add_foreign_key "ir_act_window_view", "ir_ui_view", column: "view_id", name: "ir_act_window_view_view_id_fkey", on_delete: :nullify
  add_foreign_key "ir_act_window_view", "res_users", column: "create_uid", name: "ir_act_window_view_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_act_window_view", "res_users", column: "write_uid", name: "ir_act_window_view_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_actions", "ir_model", column: "binding_model_id", name: "ir_actions_binding_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_actions", "res_users", column: "create_uid", name: "ir_actions_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_actions", "res_users", column: "write_uid", name: "ir_actions_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_actions_todo", "res_users", column: "create_uid", name: "ir_actions_todo_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_actions_todo", "res_users", column: "write_uid", name: "ir_actions_todo_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_attachment", "res_company", column: "company_id", name: "ir_attachment_company_id_fkey", on_delete: :nullify
  add_foreign_key "ir_attachment", "res_users", column: "create_uid", name: "ir_attachment_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_attachment", "res_users", column: "write_uid", name: "ir_attachment_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_config_parameter", "res_users", column: "create_uid", name: "ir_config_parameter_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_config_parameter", "res_users", column: "write_uid", name: "ir_config_parameter_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_cron", "ir_act_server", column: "ir_actions_server_id", name: "ir_cron_ir_actions_server_id_fkey", on_delete: :restrict
  add_foreign_key "ir_cron", "res_users", column: "create_uid", name: "ir_cron_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_cron", "res_users", column: "user_id", name: "ir_cron_user_id_fkey", on_delete: :nullify
  add_foreign_key "ir_cron", "res_users", column: "write_uid", name: "ir_cron_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_default", "ir_model_fields", column: "field_id", name: "ir_default_field_id_fkey", on_delete: :cascade
  add_foreign_key "ir_default", "res_company", column: "company_id", name: "ir_default_company_id_fkey", on_delete: :cascade
  add_foreign_key "ir_default", "res_users", column: "create_uid", name: "ir_default_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_default", "res_users", column: "user_id", name: "ir_default_user_id_fkey", on_delete: :cascade
  add_foreign_key "ir_default", "res_users", column: "write_uid", name: "ir_default_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_exports", "ir_model", column: "model_id", name: "ir_exports_model_id_fkey", on_delete: :nullify
  add_foreign_key "ir_exports", "res_users", column: "create_uid", name: "ir_exports_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_exports", "res_users", column: "write_uid", name: "ir_exports_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_exports_line", "ir_exports", column: "export_id", name: "ir_exports_line_export_id_fkey", on_delete: :cascade
  add_foreign_key "ir_exports_line", "ir_model_fields", column: "field1_id", name: "ir_exports_line_field1_id_fkey", on_delete: :nullify
  add_foreign_key "ir_exports_line", "ir_model_fields", column: "field2_id", name: "ir_exports_line_field2_id_fkey", on_delete: :nullify
  add_foreign_key "ir_exports_line", "ir_model_fields", column: "field3_id", name: "ir_exports_line_field3_id_fkey", on_delete: :nullify
  add_foreign_key "ir_exports_line", "ir_model_fields", column: "field4_id", name: "ir_exports_line_field4_id_fkey", on_delete: :nullify
  add_foreign_key "ir_exports_line", "res_users", column: "create_uid", name: "ir_exports_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_exports_line", "res_users", column: "write_uid", name: "ir_exports_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_filters", "res_users", column: "create_uid", name: "ir_filters_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_filters", "res_users", column: "user_id", name: "ir_filters_user_id_fkey", on_delete: :cascade
  add_foreign_key "ir_filters", "res_users", column: "write_uid", name: "ir_filters_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_logging", "res_users", column: "write_uid", name: "ir_logging_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_logging_perf_rule", "res_users", column: "create_uid", name: "ir_logging_perf_rule_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_logging_perf_rule", "res_users", column: "write_uid", name: "ir_logging_perf_rule_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_logging_perf_rule_ir_model_rel", "ir_logging_perf_rule", name: "ir_logging_perf_rule_ir_model_rel_ir_logging_perf_rule_id_fkey", on_delete: :cascade
  add_foreign_key "ir_logging_perf_rule_ir_model_rel", "ir_model", name: "ir_logging_perf_rule_ir_model_rel_ir_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_logging_perf_rule_res_users_rel", "ir_logging_perf_rule", name: "ir_logging_perf_rule_res_users_rel_ir_logging_perf_rule_id_fkey", on_delete: :cascade
  add_foreign_key "ir_logging_perf_rule_res_users_rel", "res_users", column: "res_users_id", name: "ir_logging_perf_rule_res_users_rel_res_users_id_fkey", on_delete: :cascade
  add_foreign_key "ir_mail_server", "res_users", column: "create_uid", name: "ir_mail_server_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_mail_server", "res_users", column: "write_uid", name: "ir_mail_server_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model", "ir_model_fields", column: "website_form_default_field_id", name: "ir_model_website_form_default_field_id_fkey", on_delete: :nullify
  add_foreign_key "ir_model", "res_users", column: "create_uid", name: "ir_model_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model", "res_users", column: "write_uid", name: "ir_model_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_access", "ir_model", column: "model_id", name: "ir_model_access_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_model_access", "res_groups", column: "group_id", name: "ir_model_access_group_id_fkey", on_delete: :cascade
  add_foreign_key "ir_model_access", "res_users", column: "create_uid", name: "ir_model_access_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_access", "res_users", column: "write_uid", name: "ir_model_access_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_constraint", "ir_model", column: "model", name: "ir_model_constraint_model_fkey", on_delete: :cascade
  add_foreign_key "ir_model_constraint", "ir_module_module", column: "module", name: "ir_model_constraint_module_fkey", on_delete: :nullify
  add_foreign_key "ir_model_constraint", "res_users", column: "create_uid", name: "ir_model_constraint_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_constraint", "res_users", column: "write_uid", name: "ir_model_constraint_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_data", "res_users", column: "create_uid", name: "ir_model_data_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_data", "res_users", column: "write_uid", name: "ir_model_data_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_fields", "ir_model", column: "model_id", name: "ir_model_fields_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_model_fields", "ir_model_fields", column: "serialization_field_id", name: "ir_model_fields_serialization_field_id_fkey", on_delete: :cascade
  add_foreign_key "ir_model_fields", "res_users", column: "create_uid", name: "ir_model_fields_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_fields", "res_users", column: "write_uid", name: "ir_model_fields_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_fields_group_rel", "ir_model_fields", column: "field_id", name: "ir_model_fields_group_rel_field_id_fkey", on_delete: :cascade
  add_foreign_key "ir_model_fields_group_rel", "res_groups", column: "group_id", name: "ir_model_fields_group_rel_group_id_fkey", on_delete: :cascade
  add_foreign_key "ir_model_relation", "ir_model", column: "model", name: "ir_model_relation_model_fkey", on_delete: :nullify
  add_foreign_key "ir_model_relation", "ir_module_module", column: "module", name: "ir_model_relation_module_fkey", on_delete: :nullify
  add_foreign_key "ir_model_relation", "res_users", column: "create_uid", name: "ir_model_relation_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_model_relation", "res_users", column: "write_uid", name: "ir_model_relation_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_module_category", "ir_module_category", column: "parent_id", name: "ir_module_category_parent_id_fkey", on_delete: :nullify
  add_foreign_key "ir_module_category", "res_users", column: "create_uid", name: "ir_module_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_module_category", "res_users", column: "write_uid", name: "ir_module_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_module_module", "ir_module_category", column: "category_id", name: "ir_module_module_category_id_fkey", on_delete: :nullify
  add_foreign_key "ir_module_module", "res_users", column: "create_uid", name: "ir_module_module_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_module_module", "res_users", column: "write_uid", name: "ir_module_module_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_module_module_dependency", "ir_module_module", column: "module_id", name: "ir_module_module_dependency_module_id_fkey", on_delete: :cascade
  add_foreign_key "ir_module_module_dependency", "res_users", column: "create_uid", name: "ir_module_module_dependency_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_module_module_dependency", "res_users", column: "write_uid", name: "ir_module_module_dependency_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_module_module_exclusion", "ir_module_module", column: "module_id", name: "ir_module_module_exclusion_module_id_fkey", on_delete: :cascade
  add_foreign_key "ir_module_module_exclusion", "res_users", column: "create_uid", name: "ir_module_module_exclusion_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_module_module_exclusion", "res_users", column: "write_uid", name: "ir_module_module_exclusion_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_property", "ir_model_fields", column: "fields_id", name: "ir_property_fields_id_fkey", on_delete: :cascade
  add_foreign_key "ir_property", "res_company", column: "company_id", name: "ir_property_company_id_fkey", on_delete: :nullify
  add_foreign_key "ir_property", "res_users", column: "create_uid", name: "ir_property_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_property", "res_users", column: "write_uid", name: "ir_property_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_rule", "ir_model", column: "model_id", name: "ir_rule_model_id_fkey", on_delete: :cascade
  add_foreign_key "ir_rule", "res_users", column: "create_uid", name: "ir_rule_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_rule", "res_users", column: "write_uid", name: "ir_rule_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_sequence", "res_company", column: "company_id", name: "ir_sequence_company_id_fkey", on_delete: :nullify
  add_foreign_key "ir_sequence", "res_users", column: "create_uid", name: "ir_sequence_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_sequence", "res_users", column: "write_uid", name: "ir_sequence_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_sequence_date_range", "ir_sequence", column: "sequence_id", name: "ir_sequence_date_range_sequence_id_fkey", on_delete: :cascade
  add_foreign_key "ir_sequence_date_range", "res_users", column: "create_uid", name: "ir_sequence_date_range_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_sequence_date_range", "res_users", column: "write_uid", name: "ir_sequence_date_range_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_server_object_lines", "ir_act_server", column: "server_id", name: "ir_server_object_lines_server_id_fkey", on_delete: :cascade
  add_foreign_key "ir_server_object_lines", "ir_model_fields", column: "col1", name: "ir_server_object_lines_col1_fkey", on_delete: :nullify
  add_foreign_key "ir_server_object_lines", "res_users", column: "create_uid", name: "ir_server_object_lines_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_server_object_lines", "res_users", column: "write_uid", name: "ir_server_object_lines_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_translation", "res_lang", column: "lang", primary_key: "code", name: "ir_translation_lang_fkey_res_lang"
  add_foreign_key "ir_ui_menu", "ir_ui_menu", column: "parent_id", name: "ir_ui_menu_parent_id_fkey", on_delete: :restrict
  add_foreign_key "ir_ui_menu", "res_users", column: "create_uid", name: "ir_ui_menu_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_ui_menu", "res_users", column: "write_uid", name: "ir_ui_menu_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_ui_menu_group_rel", "ir_ui_menu", column: "menu_id", name: "ir_ui_menu_group_rel_menu_id_fkey", on_delete: :cascade
  add_foreign_key "ir_ui_menu_group_rel", "res_groups", column: "gid", name: "ir_ui_menu_group_rel_gid_fkey", on_delete: :cascade
  add_foreign_key "ir_ui_view", "ir_ui_view", column: "inherit_id", name: "ir_ui_view_inherit_id_fkey", on_delete: :restrict
  add_foreign_key "ir_ui_view", "res_users", column: "create_uid", name: "ir_ui_view_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_ui_view", "res_users", column: "write_uid", name: "ir_ui_view_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_ui_view", "website", name: "ir_ui_view_website_id_fkey", on_delete: :cascade
  add_foreign_key "ir_ui_view_custom", "ir_ui_view", column: "ref_id", name: "ir_ui_view_custom_ref_id_fkey", on_delete: :cascade
  add_foreign_key "ir_ui_view_custom", "res_users", column: "create_uid", name: "ir_ui_view_custom_create_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_ui_view_custom", "res_users", column: "user_id", name: "ir_ui_view_custom_user_id_fkey", on_delete: :cascade
  add_foreign_key "ir_ui_view_custom", "res_users", column: "write_uid", name: "ir_ui_view_custom_write_uid_fkey", on_delete: :nullify
  add_foreign_key "ir_ui_view_group_rel", "ir_ui_view", column: "view_id", name: "ir_ui_view_group_rel_view_id_fkey", on_delete: :cascade
  add_foreign_key "ir_ui_view_group_rel", "res_groups", column: "group_id", name: "ir_ui_view_group_rel_group_id_fkey", on_delete: :cascade
  add_foreign_key "issue_media", "op_faculty", column: "faculty_id", name: "issue_media_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "issue_media", "op_library_card", column: "library_card_id", name: "issue_media_library_card_id_fkey", on_delete: :nullify
  add_foreign_key "issue_media", "op_media", column: "media_id", name: "issue_media_media_id_fkey", on_delete: :nullify
  add_foreign_key "issue_media", "op_media_unit", column: "media_unit_id", name: "issue_media_media_unit_id_fkey", on_delete: :nullify
  add_foreign_key "issue_media", "op_student", column: "student_id", name: "issue_media_student_id_fkey", on_delete: :nullify
  add_foreign_key "issue_media", "res_users", column: "create_uid", name: "issue_media_create_uid_fkey", on_delete: :nullify
  add_foreign_key "issue_media", "res_users", column: "write_uid", name: "issue_media_write_uid_fkey", on_delete: :nullify
  add_foreign_key "job_cv_rel", "hr_job", column: "job_id", name: "job_cv_rel_job_id_fkey", on_delete: :cascade
  add_foreign_key "job_cv_rel", "ir_attachment", column: "cv_id", name: "job_cv_rel_cv_id_fkey", on_delete: :cascade
  add_foreign_key "learning_materials", "op_lession"
  add_foreign_key "link_tracker", "mail_mass_mailing", column: "mass_mailing_id", name: "link_tracker_mass_mailing_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker", "mail_mass_mailing_campaign", column: "mass_mailing_campaign_id", name: "link_tracker_mass_mailing_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker", "res_users", column: "create_uid", name: "link_tracker_create_uid_fkey", on_delete: :nullify
  add_foreign_key "link_tracker", "res_users", column: "write_uid", name: "link_tracker_write_uid_fkey", on_delete: :nullify
  add_foreign_key "link_tracker", "utm_campaign", column: "campaign_id", name: "link_tracker_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker", "utm_medium", column: "medium_id", name: "link_tracker_medium_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker", "utm_source", column: "source_id", name: "link_tracker_source_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker_click", "link_tracker", column: "link_id", name: "link_tracker_click_link_id_fkey", on_delete: :cascade
  add_foreign_key "link_tracker_click", "mail_mail_statistics", column: "mail_stat_id", name: "link_tracker_click_mail_stat_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker_click", "mail_mass_mailing", column: "mass_mailing_id", name: "link_tracker_click_mass_mailing_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker_click", "mail_mass_mailing_campaign", column: "mass_mailing_campaign_id", name: "link_tracker_click_mass_mailing_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker_click", "res_country", column: "country_id", name: "link_tracker_click_country_id_fkey", on_delete: :nullify
  add_foreign_key "link_tracker_click", "res_users", column: "create_uid", name: "link_tracker_click_create_uid_fkey", on_delete: :nullify
  add_foreign_key "link_tracker_click", "res_users", column: "write_uid", name: "link_tracker_click_write_uid_fkey", on_delete: :nullify
  add_foreign_key "link_tracker_code", "link_tracker", column: "link_id", name: "link_tracker_code_link_id_fkey", on_delete: :cascade
  add_foreign_key "link_tracker_code", "res_users", column: "create_uid", name: "link_tracker_code_create_uid_fkey", on_delete: :nullify
  add_foreign_key "link_tracker_code", "res_users", column: "write_uid", name: "link_tracker_code_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_activity", "calendar_event", name: "mail_activity_calendar_event_id_fkey", on_delete: :cascade
  add_foreign_key "mail_activity", "ir_model", column: "res_model_id", name: "mail_activity_res_model_id_fkey", on_delete: :cascade
  add_foreign_key "mail_activity", "mail_activity_type", column: "activity_type_id", name: "mail_activity_activity_type_id_fkey", on_delete: :nullify
  add_foreign_key "mail_activity", "mail_activity_type", column: "previous_activity_type_id", name: "mail_activity_previous_activity_type_id_fkey", on_delete: :nullify
  add_foreign_key "mail_activity", "mail_activity_type", column: "recommended_activity_type_id", name: "mail_activity_recommended_activity_type_id_fkey", on_delete: :nullify
  add_foreign_key "mail_activity", "res_users", column: "create_uid", name: "mail_activity_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_activity", "res_users", column: "user_id", name: "mail_activity_user_id_fkey", on_delete: :nullify
  add_foreign_key "mail_activity", "res_users", column: "write_uid", name: "mail_activity_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_activity_rel", "mail_activity_type", column: "activity_id", name: "mail_activity_rel_activity_id_fkey", on_delete: :cascade
  add_foreign_key "mail_activity_rel", "mail_activity_type", column: "recommended_id", name: "mail_activity_rel_recommended_id_fkey", on_delete: :cascade
  add_foreign_key "mail_activity_type", "ir_model", column: "res_model_id", name: "mail_activity_type_res_model_id_fkey", on_delete: :nullify
  add_foreign_key "mail_activity_type", "res_users", column: "create_uid", name: "mail_activity_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_activity_type", "res_users", column: "write_uid", name: "mail_activity_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_alias", "ir_model", column: "alias_model_id", name: "mail_alias_alias_model_id_fkey", on_delete: :cascade
  add_foreign_key "mail_alias", "ir_model", column: "alias_parent_model_id", name: "mail_alias_alias_parent_model_id_fkey", on_delete: :nullify
  add_foreign_key "mail_alias", "res_users", column: "alias_user_id", name: "mail_alias_alias_user_id_fkey", on_delete: :nullify
  add_foreign_key "mail_alias", "res_users", column: "create_uid", name: "mail_alias_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_alias", "res_users", column: "write_uid", name: "mail_alias_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_channel", "im_livechat_channel", column: "livechat_channel_id", name: "mail_channel_livechat_channel_id_fkey", on_delete: :nullify
  add_foreign_key "mail_channel", "mail_alias", column: "alias_id", name: "mail_channel_alias_id_fkey", on_delete: :restrict
  add_foreign_key "mail_channel", "res_groups", column: "group_public_id", name: "mail_channel_group_public_id_fkey", on_delete: :nullify
  add_foreign_key "mail_channel", "res_users", column: "create_uid", name: "mail_channel_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_channel", "res_users", column: "write_uid", name: "mail_channel_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_channel_mail_wizard_invite_rel", "mail_channel", name: "mail_channel_mail_wizard_invite_rel_mail_channel_id_fkey", on_delete: :cascade
  add_foreign_key "mail_channel_mail_wizard_invite_rel", "mail_wizard_invite", name: "mail_channel_mail_wizard_invite_rel_mail_wizard_invite_id_fkey", on_delete: :cascade
  add_foreign_key "mail_channel_partner", "mail_channel", column: "channel_id", name: "mail_channel_partner_channel_id_fkey", on_delete: :cascade
  add_foreign_key "mail_channel_partner", "mail_message", column: "seen_message_id", name: "mail_channel_partner_seen_message_id_fkey", on_delete: :nullify
  add_foreign_key "mail_channel_partner", "res_partner", column: "partner_id", name: "mail_channel_partner_partner_id_fkey", on_delete: :cascade
  add_foreign_key "mail_channel_partner", "res_users", column: "create_uid", name: "mail_channel_partner_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_channel_partner", "res_users", column: "write_uid", name: "mail_channel_partner_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_channel_res_groups_rel", "mail_channel", name: "mail_channel_res_groups_rel_mail_channel_id_fkey", on_delete: :cascade
  add_foreign_key "mail_channel_res_groups_rel", "res_groups", column: "res_groups_id", name: "mail_channel_res_groups_rel_res_groups_id_fkey", on_delete: :cascade
  add_foreign_key "mail_compose_message", "ir_mail_server", column: "mail_server_id", name: "mail_compose_message_mail_server_id_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message", "mail_activity_type", name: "mail_compose_message_mail_activity_type_id_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message", "mail_mass_mailing", column: "mass_mailing_id", name: "mail_compose_message_mass_mailing_id_fkey", on_delete: :cascade
  add_foreign_key "mail_compose_message", "mail_mass_mailing_campaign", column: "mass_mailing_campaign_id", name: "mail_compose_message_mass_mailing_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message", "mail_message", column: "parent_id", name: "mail_compose_message_parent_id_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message", "mail_message_subtype", column: "subtype_id", name: "mail_compose_message_subtype_id_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message", "mail_template", column: "template_id", name: "mail_compose_message_template_id_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message", "res_partner", column: "author_id", name: "mail_compose_message_author_id_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message", "res_users", column: "create_uid", name: "mail_compose_message_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message", "res_users", column: "write_uid", name: "mail_compose_message_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_compose_message_ir_attachments_rel", "ir_attachment", column: "attachment_id", name: "mail_compose_message_ir_attachments_rel_attachment_id_fkey", on_delete: :cascade
  add_foreign_key "mail_compose_message_ir_attachments_rel", "mail_compose_message", column: "wizard_id", name: "mail_compose_message_ir_attachments_rel_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "mail_compose_message_mail_mass_mailing_list_rel", "mail_compose_message", name: "mail_compose_message_mail_mass_mai_mail_compose_message_id_fkey", on_delete: :cascade
  add_foreign_key "mail_compose_message_mail_mass_mailing_list_rel", "mail_mass_mailing_list", name: "mail_compose_message_mail_mass_m_mail_mass_mailing_list_id_fkey", on_delete: :cascade
  add_foreign_key "mail_compose_message_res_partner_rel", "mail_compose_message", column: "wizard_id", name: "mail_compose_message_res_partner_rel_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "mail_compose_message_res_partner_rel", "res_partner", column: "partner_id", name: "mail_compose_message_res_partner_rel_partner_id_fkey", on_delete: :cascade
  add_foreign_key "mail_followers", "mail_channel", column: "channel_id", name: "mail_followers_channel_id_fkey", on_delete: :cascade
  add_foreign_key "mail_followers", "res_partner", column: "partner_id", name: "mail_followers_partner_id_fkey", on_delete: :cascade
  add_foreign_key "mail_followers_mail_message_subtype_rel", "mail_followers", column: "mail_followers_id", name: "mail_followers_mail_message_subtype_rel_mail_followers_id_fkey", on_delete: :cascade
  add_foreign_key "mail_followers_mail_message_subtype_rel", "mail_message_subtype", name: "mail_followers_mail_message_subtyp_mail_message_subtype_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mail", "fetchmail_server", name: "mail_mail_fetchmail_server_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mail", "mail_mass_mailing", column: "mailing_id", name: "mail_mail_mailing_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mail", "mail_message", name: "mail_mail_mail_message_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mail", "res_users", column: "create_uid", name: "mail_mail_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mail", "res_users", column: "write_uid", name: "mail_mail_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mail_res_partner_rel", "mail_mail", name: "mail_mail_res_partner_rel_mail_mail_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mail_res_partner_rel", "res_partner", name: "mail_mail_res_partner_rel_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mail_statistics", "mail_mail", name: "mail_mail_statistics_mail_mail_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mail_statistics", "mail_mass_mailing", column: "mass_mailing_id", name: "mail_mail_statistics_mass_mailing_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mail_statistics", "mail_mass_mailing_campaign", column: "mass_mailing_campaign_id", name: "mail_mail_statistics_mass_mailing_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mail_statistics", "res_users", column: "create_uid", name: "mail_mail_statistics_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mail_statistics", "res_users", column: "write_uid", name: "mail_mail_statistics_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing", "ir_model", column: "mailing_model_id", name: "mail_mass_mailing_mailing_model_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing", "mail_mass_mailing_campaign", column: "mass_mailing_campaign_id", name: "mail_mass_mailing_mass_mailing_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing", "res_users", column: "create_uid", name: "mail_mass_mailing_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing", "res_users", column: "write_uid", name: "mail_mass_mailing_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing", "utm_campaign", column: "campaign_id", name: "mail_mass_mailing_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing", "utm_medium", column: "medium_id", name: "mail_mass_mailing_medium_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing", "utm_source", column: "source_id", name: "mail_mass_mailing_source_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_campaign", "mail_mass_mailing_stage", column: "stage_id", name: "mail_mass_mailing_campaign_stage_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_campaign", "res_users", column: "create_uid", name: "mail_mass_mailing_campaign_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_campaign", "res_users", column: "user_id", name: "mail_mass_mailing_campaign_user_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_campaign", "res_users", column: "write_uid", name: "mail_mass_mailing_campaign_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_campaign", "utm_campaign", column: "campaign_id", name: "mail_mass_mailing_campaign_campaign_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_campaign", "utm_medium", column: "medium_id", name: "mail_mass_mailing_campaign_medium_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_campaign", "utm_source", column: "source_id", name: "mail_mass_mailing_campaign_source_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_contact", "res_country", column: "country_id", name: "mail_mass_mailing_contact_country_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_contact", "res_partner_title", column: "title_id", name: "mail_mass_mailing_contact_title_id_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_contact", "res_users", column: "create_uid", name: "mail_mass_mailing_contact_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_contact", "res_users", column: "write_uid", name: "mail_mass_mailing_contact_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_contact_list_rel", "mail_mass_mailing_contact", column: "contact_id", name: "mail_mass_mailing_contact_list_rel_contact_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_contact_list_rel", "mail_mass_mailing_list", column: "list_id", name: "mail_mass_mailing_contact_list_rel_list_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_contact_res_partner_category_rel", "mail_mass_mailing_contact", name: "mail_mass_mailing_contact_res_mail_mass_mailing_contact_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_contact_res_partner_category_rel", "res_partner_category", name: "mail_mass_mailing_contact_res_part_res_partner_category_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_list", "res_users", column: "create_uid", name: "mail_mass_mailing_list_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_list", "res_users", column: "write_uid", name: "mail_mass_mailing_list_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_list_rel", "mail_mass_mailing", name: "mail_mass_mailing_list_rel_mail_mass_mailing_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_list_rel", "mail_mass_mailing_list", name: "mail_mass_mailing_list_rel_mail_mass_mailing_list_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_list_survey_mail_compose_message_rel", "mail_mass_mailing_list", name: "mail_mass_mailing_list_survey_ma_mail_mass_mailing_list_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_list_survey_mail_compose_message_rel", "survey_mail_compose_message", name: "mail_mass_mailing_list_survey_survey_mail_compose_message__fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_stage", "res_users", column: "create_uid", name: "mail_mass_mailing_stage_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_stage", "res_users", column: "write_uid", name: "mail_mass_mailing_stage_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_tag", "res_users", column: "create_uid", name: "mail_mass_mailing_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_tag", "res_users", column: "write_uid", name: "mail_mass_mailing_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_tag_rel", "mail_mass_mailing_campaign", column: "tag_id", name: "mail_mass_mailing_tag_rel_tag_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_tag_rel", "mail_mass_mailing_tag", column: "campaign_id", name: "mail_mass_mailing_tag_rel_campaign_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_test", "mail_mass_mailing", column: "mass_mailing_id", name: "mail_mass_mailing_test_mass_mailing_id_fkey", on_delete: :cascade
  add_foreign_key "mail_mass_mailing_test", "res_users", column: "create_uid", name: "mail_mass_mailing_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_mass_mailing_test", "res_users", column: "write_uid", name: "mail_mass_mailing_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_message", "ir_mail_server", column: "mail_server_id", name: "mail_message_mail_server_id_fkey", on_delete: :nullify
  add_foreign_key "mail_message", "mail_activity_type", name: "mail_message_mail_activity_type_id_fkey", on_delete: :nullify
  add_foreign_key "mail_message", "mail_message", column: "parent_id", name: "mail_message_parent_id_fkey", on_delete: :nullify
  add_foreign_key "mail_message", "mail_message_subtype", column: "subtype_id", name: "mail_message_subtype_id_fkey", on_delete: :nullify
  add_foreign_key "mail_message", "res_partner", column: "author_id", name: "mail_message_author_id_fkey", on_delete: :nullify
  add_foreign_key "mail_message", "res_users", column: "create_uid", name: "mail_message_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_message", "res_users", column: "write_uid", name: "mail_message_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_message_mail_channel_rel", "mail_channel", name: "mail_message_mail_channel_rel_mail_channel_id_fkey", on_delete: :cascade
  add_foreign_key "mail_message_mail_channel_rel", "mail_message", name: "mail_message_mail_channel_rel_mail_message_id_fkey", on_delete: :cascade
  add_foreign_key "mail_message_res_partner_needaction_rel", "mail_message", name: "mail_message_res_partner_needaction_rel_mail_message_id_fkey", on_delete: :cascade
  add_foreign_key "mail_message_res_partner_needaction_rel", "res_partner", name: "mail_message_res_partner_needaction_rel_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "mail_message_res_partner_rel", "mail_message", name: "mail_message_res_partner_rel_mail_message_id_fkey", on_delete: :cascade
  add_foreign_key "mail_message_res_partner_rel", "res_partner", name: "mail_message_res_partner_rel_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "mail_message_res_partner_starred_rel", "mail_message", name: "mail_message_res_partner_starred_rel_mail_message_id_fkey", on_delete: :cascade
  add_foreign_key "mail_message_res_partner_starred_rel", "res_partner", name: "mail_message_res_partner_starred_rel_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "mail_message_subtype", "mail_message_subtype", column: "parent_id", name: "mail_message_subtype_parent_id_fkey", on_delete: :nullify
  add_foreign_key "mail_message_subtype", "res_users", column: "create_uid", name: "mail_message_subtype_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_message_subtype", "res_users", column: "write_uid", name: "mail_message_subtype_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_shortcode", "res_users", column: "create_uid", name: "mail_shortcode_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_shortcode", "res_users", column: "write_uid", name: "mail_shortcode_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "ir_act_report_xml", column: "report_template", name: "mail_template_report_template_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "ir_act_window", column: "ref_ir_act_window", name: "mail_template_ref_ir_act_window_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "ir_mail_server", column: "mail_server_id", name: "mail_template_mail_server_id_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "ir_model", column: "model_id", name: "mail_template_model_id_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "ir_model", column: "sub_object", name: "mail_template_sub_object_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "ir_model_fields", column: "model_object_field", name: "mail_template_model_object_field_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "ir_model_fields", column: "sub_model_object_field", name: "mail_template_sub_model_object_field_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "res_users", column: "create_uid", name: "mail_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_template", "res_users", column: "write_uid", name: "mail_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_test", "mail_alias", column: "alias_id", name: "mail_test_alias_id_fkey", on_delete: :restrict
  add_foreign_key "mail_test", "res_users", column: "create_uid", name: "mail_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_test", "res_users", column: "write_uid", name: "mail_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_test_simple", "res_users", column: "create_uid", name: "mail_test_simple_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_test_simple", "res_users", column: "write_uid", name: "mail_test_simple_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_email", "mail_mail", column: "mail_id", name: "mail_tracking_email_mail_id_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_email", "mail_message", name: "mail_tracking_email_mail_message_id_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_email", "res_partner", column: "partner_id", name: "mail_tracking_email_partner_id_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_email", "res_users", column: "create_uid", name: "mail_tracking_email_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_email", "res_users", column: "write_uid", name: "mail_tracking_email_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_event", "mail_tracking_email", column: "tracking_email_id", name: "mail_tracking_event_tracking_email_id_fkey", on_delete: :cascade
  add_foreign_key "mail_tracking_event", "res_country", column: "user_country_id", name: "mail_tracking_event_user_country_id_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_event", "res_users", column: "create_uid", name: "mail_tracking_event_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_event", "res_users", column: "write_uid", name: "mail_tracking_event_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_value", "mail_message", name: "mail_tracking_value_mail_message_id_fkey", on_delete: :cascade
  add_foreign_key "mail_tracking_value", "res_users", column: "create_uid", name: "mail_tracking_value_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_tracking_value", "res_users", column: "write_uid", name: "mail_tracking_value_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_wizard_invite", "res_users", column: "create_uid", name: "mail_wizard_invite_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_wizard_invite", "res_users", column: "write_uid", name: "mail_wizard_invite_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mail_wizard_invite_res_partner_rel", "mail_wizard_invite", name: "mail_wizard_invite_res_partner_rel_mail_wizard_invite_id_fkey", on_delete: :cascade
  add_foreign_key "mail_wizard_invite_res_partner_rel", "res_partner", name: "mail_wizard_invite_res_partner_rel_res_partner_id_fkey", on_delete: :cascade
  add_foreign_key "maintenance_equipment", "hr_department", column: "department_id", name: "maintenance_equipment_department_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "hr_employee", column: "employee_id", name: "maintenance_equipment_employee_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "maintenance_equipment_category", column: "category_id", name: "maintenance_equipment_category_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "maintenance_equipment_location", column: "location_id", name: "maintenance_equipment_location_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "maintenance_equipment_status", column: "status_id", name: "maintenance_equipment_status_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "maintenance_team", name: "maintenance_equipment_maintenance_team_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "res_partner", column: "partner_id", name: "maintenance_equipment_partner_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "res_users", column: "create_uid", name: "maintenance_equipment_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "res_users", column: "owner_user_id", name: "maintenance_equipment_owner_user_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "res_users", column: "technician_user_id", name: "maintenance_equipment_technician_user_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment", "res_users", column: "write_uid", name: "maintenance_equipment_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_category", "ir_sequence", column: "sequence_id", name: "maintenance_equipment_category_sequence_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_category", "mail_alias", column: "alias_id", name: "maintenance_equipment_category_alias_id_fkey", on_delete: :restrict
  add_foreign_key "maintenance_equipment_category", "maintenance_equipment_category", column: "parent_id", name: "maintenance_equipment_category_parent_id_fkey", on_delete: :cascade
  add_foreign_key "maintenance_equipment_category", "res_users", column: "create_uid", name: "maintenance_equipment_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_category", "res_users", column: "technician_user_id", name: "maintenance_equipment_category_technician_user_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_category", "res_users", column: "write_uid", name: "maintenance_equipment_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_category_maintenance_equipment_status_rel", "maintenance_equipment_category", name: "maintenance_equipment_categor_maintenance_equipment_catego_fkey", on_delete: :cascade
  add_foreign_key "maintenance_equipment_category_maintenance_equipment_status_rel", "maintenance_equipment_status", name: "maintenance_equipment_categor_maintenance_equipment_status_fkey", on_delete: :cascade
  add_foreign_key "maintenance_equipment_location", "res_company", column: "company_id", name: "maintenance_equipment_location_company_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_location", "res_users", column: "create_uid", name: "maintenance_equipment_location_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_location", "res_users", column: "write_uid", name: "maintenance_equipment_location_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_maintenance_equipment_move_rel", "maintenance_equipment", name: "maintenance_equipment_maintenance_maintenance_equipment_id_fkey", on_delete: :cascade
  add_foreign_key "maintenance_equipment_maintenance_equipment_move_rel", "maintenance_equipment_move", name: "maintenance_equipment_mainten_maintenance_equipment_move_i_fkey", on_delete: :cascade
  add_foreign_key "maintenance_equipment_move", "maintenance_equipment_location", column: "from_location_id", name: "maintenance_equipment_move_from_location_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_move", "maintenance_equipment_location", column: "to_location_id", name: "maintenance_equipment_move_to_location_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_move", "maintenance_equipment_move_type", column: "move_type_id", name: "maintenance_equipment_move_move_type_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_move", "op_session", column: "session_id", name: "maintenance_equipment_move_session_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_move", "res_users", column: "create_uid", name: "maintenance_equipment_move_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_move", "res_users", column: "user_id", name: "maintenance_equipment_move_user_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_move", "res_users", column: "write_uid", name: "maintenance_equipment_move_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_move_type", "res_users", column: "create_uid", name: "maintenance_equipment_move_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_move_type", "res_users", column: "write_uid", name: "maintenance_equipment_move_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_status", "res_users", column: "create_uid", name: "maintenance_equipment_status_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_status", "res_users", column: "write_uid", name: "maintenance_equipment_status_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_tag", "res_users", column: "create_uid", name: "maintenance_equipment_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_equipment_tag", "res_users", column: "write_uid", name: "maintenance_equipment_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "hr_department", column: "department_id", name: "maintenance_request_department_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "hr_employee", column: "employee_id", name: "maintenance_request_employee_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "maintenance_equipment", column: "equipment_id", name: "maintenance_request_equipment_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "maintenance_equipment_category", column: "category_id", name: "maintenance_request_category_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "maintenance_stage", column: "stage_id", name: "maintenance_request_stage_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "maintenance_team", name: "maintenance_request_maintenance_team_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "res_users", column: "create_uid", name: "maintenance_request_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "res_users", column: "owner_user_id", name: "maintenance_request_owner_user_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "res_users", column: "technician_user_id", name: "maintenance_request_technician_user_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_request", "res_users", column: "write_uid", name: "maintenance_request_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_stage", "res_users", column: "create_uid", name: "maintenance_stage_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_stage", "res_users", column: "write_uid", name: "maintenance_stage_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_stage_next_stage", "maintenance_stage", column: "next_stage_id", name: "maintenance_stage_next_stage_next_stage_id_fkey", on_delete: :cascade
  add_foreign_key "maintenance_stage_next_stage", "maintenance_stage", column: "stage_id", name: "maintenance_stage_next_stage_stage_id_fkey", on_delete: :cascade
  add_foreign_key "maintenance_team", "ir_sequence", column: "sequence_id", name: "maintenance_team_sequence_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_team", "res_users", column: "create_uid", name: "maintenance_team_create_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_team", "res_users", column: "user_id", name: "maintenance_team_user_id_fkey", on_delete: :nullify
  add_foreign_key "maintenance_team", "res_users", column: "write_uid", name: "maintenance_team_write_uid_fkey", on_delete: :nullify
  add_foreign_key "maintenance_team_users_rel", "maintenance_team", name: "maintenance_team_users_rel_maintenance_team_id_fkey", on_delete: :cascade
  add_foreign_key "maintenance_team_users_rel", "res_users", column: "res_users_id", name: "maintenance_team_users_rel_res_users_id_fkey", on_delete: :cascade
  add_foreign_key "mass_editing_wizard", "res_users", column: "create_uid", name: "mass_editing_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mass_editing_wizard", "res_users", column: "write_uid", name: "mass_editing_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "mass_mailing_ir_attachments_rel", "ir_attachment", column: "attachment_id", name: "mass_mailing_ir_attachments_rel_attachment_id_fkey", on_delete: :cascade
  add_foreign_key "mass_mailing_ir_attachments_rel", "mail_mass_mailing", column: "mass_mailing_id", name: "mass_mailing_ir_attachments_rel_mass_mailing_id_fkey", on_delete: :cascade
  add_foreign_key "mass_object", "res_users", column: "create_uid", name: "mass_object_create_uid_fkey", on_delete: :nullify
  add_foreign_key "mass_object", "res_users", column: "write_uid", name: "mass_object_write_uid_fkey", on_delete: :nullify
  add_foreign_key "meeting_category_rel", "calendar_event", column: "event_id", name: "meeting_category_rel_event_id_fkey", on_delete: :cascade
  add_foreign_key "meeting_category_rel", "calendar_event_type", column: "type_id", name: "meeting_category_rel_type_id_fkey", on_delete: :cascade
  add_foreign_key "merge_opportunity_rel", "crm_lead", column: "opportunity_id", name: "merge_opportunity_rel_opportunity_id_fkey", on_delete: :cascade
  add_foreign_key "merge_opportunity_rel", "crm_merge_opportunity", column: "merge_id", name: "merge_opportunity_rel_merge_id_fkey", on_delete: :cascade
  add_foreign_key "message_attachment_rel", "ir_attachment", column: "attachment_id", name: "message_attachment_rel_attachment_id_fkey", on_delete: :cascade
  add_foreign_key "message_attachment_rel", "mail_message", column: "message_id", name: "message_attachment_rel_message_id_fkey", on_delete: :cascade
  add_foreign_key "muk_autovacuum_rules", "res_users", column: "create_uid", name: "muk_autovacuum_rules_create_uid_fkey", on_delete: :nullify
  add_foreign_key "muk_autovacuum_rules", "res_users", column: "write_uid", name: "muk_autovacuum_rules_write_uid_fkey", on_delete: :nullify
  add_foreign_key "muk_web_client_notification_send_notifications", "res_users", column: "create_uid", name: "muk_web_client_notification_send_notifications_create_uid_fkey", on_delete: :nullify
  add_foreign_key "muk_web_client_notification_send_notifications", "res_users", column: "write_uid", name: "muk_web_client_notification_send_notifications_write_uid_fkey", on_delete: :nullify
  add_foreign_key "muk_web_client_notification_user_rel", "muk_web_client_notification_send_notifications", column: "wizard_id", name: "muk_web_client_notification_user_rel_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "muk_web_client_notification_user_rel", "res_users", column: "user_id", name: "muk_web_client_notification_user_rel_user_id_fkey", on_delete: :cascade
  add_foreign_key "note_note", "res_users", column: "create_uid", name: "note_note_create_uid_fkey", on_delete: :nullify
  add_foreign_key "note_note", "res_users", column: "user_id", name: "note_note_user_id_fkey", on_delete: :nullify
  add_foreign_key "note_note", "res_users", column: "write_uid", name: "note_note_write_uid_fkey", on_delete: :nullify
  add_foreign_key "note_stage", "res_users", column: "create_uid", name: "note_stage_create_uid_fkey", on_delete: :nullify
  add_foreign_key "note_stage", "res_users", column: "user_id", name: "note_stage_user_id_fkey", on_delete: :cascade
  add_foreign_key "note_stage", "res_users", column: "write_uid", name: "note_stage_write_uid_fkey", on_delete: :nullify
  add_foreign_key "note_stage_rel", "note_note", column: "note_id", name: "note_stage_rel_note_id_fkey", on_delete: :cascade
  add_foreign_key "note_stage_rel", "note_stage", column: "stage_id", name: "note_stage_rel_stage_id_fkey", on_delete: :cascade
  add_foreign_key "note_tag", "res_users", column: "create_uid", name: "note_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "note_tag", "res_users", column: "write_uid", name: "note_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "note_tags_rel", "note_note", column: "note_id", name: "note_tags_rel_note_id_fkey", on_delete: :cascade
  add_foreign_key "note_tags_rel", "note_tag", column: "tag_id", name: "note_tags_rel_tag_id_fkey", on_delete: :cascade
  add_foreign_key "op_activity", "op_activity_type", column: "type_id", name: "op_activity_type_id_fkey", on_delete: :nullify
  add_foreign_key "op_activity", "op_faculty", column: "faculty_id", name: "op_activity_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "op_activity", "op_student", column: "student_id", name: "op_activity_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_activity", "res_users", column: "create_uid", name: "op_activity_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_activity", "res_users", column: "write_uid", name: "op_activity_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_activity_type", "res_users", column: "create_uid", name: "op_activity_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_activity_type", "res_users", column: "write_uid", name: "op_activity_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "crm_claim", column: "claim_id", name: "op_admission_claim_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "op_admission_register", column: "register_id", name: "op_admission_register_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "op_batch", column: "batch_id", name: "op_admission_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "op_course", column: "course_id", name: "op_admission_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "op_course", column: "prev_course_id", name: "op_admission_prev_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "op_fees_terms", column: "fees_term_id", name: "op_admission_fees_term_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "op_student", column: "student_id", name: "op_admission_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "res_company", column: "company_id", name: "op_admission_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "res_country", column: "country_id", name: "op_admission_country_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "res_country_state", column: "state_id", name: "op_admission_state_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "res_partner", column: "partner_id", name: "op_admission_partner_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "res_partner", column: "prev_institute_id", name: "op_admission_prev_institute_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "res_partner_title", column: "title", name: "op_admission_title_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "res_users", column: "create_uid", name: "op_admission_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "res_users", column: "write_uid", name: "op_admission_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "sale_order", name: "op_admission_sale_order_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission", "sale_order_line", name: "op_admission_sale_order_line_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission_register", "op_batch", column: "batch_id", name: "op_admission_register_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission_register", "op_course", column: "course_id", name: "op_admission_register_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission_register", "product_product", column: "product_id", name: "op_admission_register_product_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission_register", "res_company", column: "company_id", name: "op_admission_register_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_admission_register", "res_users", column: "create_uid", name: "op_admission_register_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_admission_register", "res_users", column: "write_uid", name: "op_admission_register_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_admission_student_test_rel", "op_admission", name: "op_admission_student_test_rel_op_admission_id_fkey", on_delete: :cascade
  add_foreign_key "op_admission_student_test_rel", "student_test", name: "op_admission_student_test_rel_student_test_id_fkey", on_delete: :cascade
  add_foreign_key "op_admission_subject_rel", "op_admission", column: "admission_id", name: "op_admission_subject_rel_admission_id_fkey", on_delete: :cascade
  add_foreign_key "op_admission_subject_rel", "op_subject", column: "subject_id", name: "op_admission_subject_rel_subject_id_fkey", on_delete: :cascade
  add_foreign_key "op_all_student", "op_batch", column: "batch_id", name: "op_all_student_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_all_student", "op_course", column: "course_id", name: "op_all_student_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_all_student", "res_users", column: "create_uid", name: "op_all_student_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_all_student", "res_users", column: "write_uid", name: "op_all_student_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_all_student_op_student_rel", "op_all_student", name: "op_all_student_op_student_rel_op_all_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_all_student_op_student_rel", "op_student", name: "op_all_student_op_student_rel_op_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_asset", "op_classroom", column: "asset_id", name: "op_asset_asset_id_fkey", on_delete: :nullify
  add_foreign_key "op_asset", "product_product", column: "product_id", name: "op_asset_product_id_fkey", on_delete: :nullify
  add_foreign_key "op_asset", "res_users", column: "create_uid", name: "op_asset_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_asset", "res_users", column: "write_uid", name: "op_asset_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_assignment", "op_assignment_type", column: "assignment_type_id", name: "op_assignment_assignment_type_id_fkey", on_delete: :nullify
  add_foreign_key "op_assignment", "op_batch", column: "batch_id", name: "op_assignment_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_assignment", "op_course", column: "course_id", name: "op_assignment_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_assignment", "op_faculty", column: "faculty_id", name: "op_assignment_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "op_assignment", "op_faculty", column: "reviewer", name: "op_assignment_reviewer_fkey", on_delete: :nullify
  add_foreign_key "op_assignment", "op_subject", column: "subject_id", name: "op_assignment_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_assignment", "res_users", column: "create_uid", name: "op_assignment_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_assignment", "res_users", column: "write_uid", name: "op_assignment_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_assignment_op_student_rel", "op_assignment", name: "op_assignment_op_student_rel_op_assignment_id_fkey", on_delete: :cascade
  add_foreign_key "op_assignment_op_student_rel", "op_student", name: "op_assignment_op_student_rel_op_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_assignment_sub_line", "op_assignment", column: "assignment_id", name: "op_assignment_sub_line_assignment_id_fkey", on_delete: :nullify
  add_foreign_key "op_assignment_sub_line", "op_student", column: "student_id", name: "op_assignment_sub_line_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_assignment_sub_line", "res_users", column: "create_uid", name: "op_assignment_sub_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_assignment_sub_line", "res_users", column: "write_uid", name: "op_assignment_sub_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_assignment_type", "res_users", column: "create_uid", name: "op_assignment_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_assignment_type", "res_users", column: "write_uid", name: "op_assignment_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_line", "op_attendance_register", column: "register_id", name: "op_attendance_line_register_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_line", "op_attendance_sheet", column: "attendance_id", name: "op_attendance_line_attendance_id_fkey", on_delete: :cascade
  add_foreign_key "op_attendance_line", "op_batch", column: "batch_id", name: "op_attendance_line_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_line", "op_course", column: "course_id", name: "op_attendance_line_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_line", "op_session", column: "session_id", name: "op_attendance_line_session_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_line", "op_student", column: "student_id", name: "op_attendance_line_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_line", "res_company", column: "company_id", name: "op_attendance_line_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_line", "res_users", column: "create_uid", name: "op_attendance_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_line", "res_users", column: "write_uid", name: "op_attendance_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_register", "op_batch", column: "batch_id", name: "op_attendance_register_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_register", "op_course", column: "course_id", name: "op_attendance_register_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_register", "op_subject", column: "subject_id", name: "op_attendance_register_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_register", "res_users", column: "create_uid", name: "op_attendance_register_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_register", "res_users", column: "write_uid", name: "op_attendance_register_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "op_attendance_register", column: "register_id", name: "op_attendance_sheet_register_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "op_batch", column: "batch_id", name: "op_attendance_sheet_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "op_course", column: "course_id", name: "op_attendance_sheet_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "op_faculty", column: "faculty_id", name: "op_attendance_sheet_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "op_faculty", column: "tutors_id", name: "op_attendance_sheet_tutors_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "op_lession", column: "lession_id", name: "op_attendance_sheet_lession_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "op_session", column: "session_id", name: "op_attendance_sheet_session_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "op_subject", column: "subject_id", name: "op_attendance_sheet_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "res_company", column: "company_id", name: "op_attendance_sheet_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "res_users", column: "create_uid", name: "op_attendance_sheet_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_attendance_sheet", "res_users", column: "write_uid", name: "op_attendance_sheet_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_author", "res_partner", column: "address", name: "op_author_address_fkey", on_delete: :nullify
  add_foreign_key "op_author", "res_users", column: "create_uid", name: "op_author_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_author", "res_users", column: "write_uid", name: "op_author_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_author_op_media_rel", "op_author", name: "op_author_op_media_rel_op_author_id_fkey", on_delete: :cascade
  add_foreign_key "op_author_op_media_rel", "op_media", column: "op_media_id", name: "op_author_op_media_rel_op_media_id_fkey", on_delete: :cascade
  add_foreign_key "op_badge_student", "op_gamification_badge", column: "badge_id", name: "op_badge_student_badge_id_fkey", on_delete: :cascade
  add_foreign_key "op_badge_student", "op_student", column: "student_id", name: "op_badge_student_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_badge_student", "res_users", column: "create_uid", name: "op_badge_student_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_badge_student", "res_users", column: "sender_id", name: "op_badge_student_sender_id_fkey", on_delete: :nullify
  add_foreign_key "op_badge_student", "res_users", column: "write_uid", name: "op_badge_student_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_badge_student_wizard", "op_gamification_badge", column: "badge_id", name: "op_badge_student_wizard_badge_id_fkey", on_delete: :nullify
  add_foreign_key "op_badge_student_wizard", "op_student", column: "student_id", name: "op_badge_student_wizard_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_badge_student_wizard", "res_users", column: "create_uid", name: "op_badge_student_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_badge_student_wizard", "res_users", column: "write_uid", name: "op_badge_student_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_batch", "op_admission_register", column: "register_id", name: "op_batch_register_id_fkey", on_delete: :nullify
  add_foreign_key "op_batch", "op_batch_type", column: "type_id", name: "op_batch_type_id_fkey", on_delete: :nullify
  add_foreign_key "op_batch", "op_course", column: "course_id", name: "op_batch_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_batch", "res_company", column: "company_id", name: "op_batch_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_batch", "res_users", column: "create_uid", name: "op_batch_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_batch", "res_users", column: "write_uid", name: "op_batch_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_batch_type", "res_users", column: "create_uid", name: "op_batch_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_batch_type", "res_users", column: "write_uid", name: "op_batch_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_board_affiliation", "res_company", column: "company_id", name: "op_board_affiliation_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_board_affiliation", "res_users", column: "create_uid", name: "op_board_affiliation_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_board_affiliation", "res_users", column: "write_uid", name: "op_board_affiliation_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_category", "res_users", column: "create_uid", name: "op_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_category", "res_users", column: "write_uid", name: "op_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_classroom", "op_batch", column: "batch_id", name: "op_classroom_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_classroom", "op_course", column: "course_id", name: "op_classroom_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_classroom", "res_company", column: "center_id", name: "op_classroom_center_id_fkey", on_delete: :nullify
  add_foreign_key "op_classroom", "res_users", column: "create_uid", name: "op_classroom_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_classroom", "res_users", column: "write_uid", name: "op_classroom_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_classroom_report_wizard", "op_classroom", column: "classroom_id", name: "op_classroom_report_wizard_classroom_id_fkey", on_delete: :nullify
  add_foreign_key "op_classroom_report_wizard", "res_company", column: "center_id", name: "op_classroom_report_wizard_center_id_fkey", on_delete: :nullify
  add_foreign_key "op_classroom_report_wizard", "res_users", column: "create_uid", name: "op_classroom_report_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_classroom_report_wizard", "res_users", column: "write_uid", name: "op_classroom_report_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_course", "course_categ", column: "categ_id", name: "op_course_categ_id_fkey", on_delete: :nullify
  add_foreign_key "op_course", "op_course", column: "parent_id", name: "op_course_parent_id_fkey", on_delete: :nullify
  add_foreign_key "op_course", "op_fees_terms", column: "fees_term_id", name: "op_course_fees_term_id_fkey", on_delete: :nullify
  add_foreign_key "op_course", "res_company", column: "company_id", name: "op_course_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_course", "res_users", column: "create_uid", name: "op_course_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_course", "res_users", column: "write_uid", name: "op_course_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_course_op_media_rel", "op_course", name: "op_course_op_media_rel_op_course_id_fkey", on_delete: :cascade
  add_foreign_key "op_course_op_media_rel", "op_media", column: "op_media_id", name: "op_course_op_media_rel_op_media_id_fkey", on_delete: :cascade
  add_foreign_key "op_course_op_subject_rel", "op_course", name: "op_course_op_subject_rel_op_course_id_fkey", on_delete: :cascade
  add_foreign_key "op_course_op_subject_rel", "op_subject", name: "op_course_op_subject_rel_op_subject_id_fkey", on_delete: :cascade
  add_foreign_key "op_course_student_test_rel", "op_course", name: "op_course_student_test_rel_op_course_id_fkey", on_delete: :cascade
  add_foreign_key "op_course_student_test_rel", "student_test", name: "op_course_student_test_rel_student_test_id_fkey", on_delete: :cascade
  add_foreign_key "op_exam", "op_batch", column: "batch_id", name: "op_exam_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam", "op_course", column: "course_id", name: "op_exam_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam", "op_exam_session", column: "session_id", name: "op_exam_session_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam", "op_subject", column: "subject_id", name: "op_exam_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam", "res_users", column: "create_uid", name: "op_exam_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam", "res_users", column: "write_uid", name: "op_exam_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam_attendees", "op_batch", column: "batch_id", name: "op_exam_attendees_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam_attendees", "op_course", column: "course_id", name: "op_exam_attendees_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam_attendees", "op_exam", column: "exam_id", name: "op_exam_attendees_exam_id_fkey", on_delete: :cascade
  add_foreign_key "op_exam_attendees", "op_exam_room", column: "room_id", name: "op_exam_attendees_room_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam_attendees", "op_student", column: "student_id", name: "op_exam_attendees_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam_attendees", "res_users", column: "create_uid", name: "op_exam_attendees_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam_attendees", "res_users", column: "write_uid", name: "op_exam_attendees_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam_attendees_op_held_exam_rel", "op_exam_attendees", column: "op_exam_attendees_id", name: "op_exam_attendees_op_held_exam_rel_op_exam_attendees_id_fkey", on_delete: :cascade
  add_foreign_key "op_exam_attendees_op_held_exam_rel", "op_held_exam", name: "op_exam_attendees_op_held_exam_rel_op_held_exam_id_fkey", on_delete: :cascade
  add_foreign_key "op_exam_op_faculty_rel", "op_exam", name: "op_exam_op_faculty_rel_op_exam_id_fkey", on_delete: :cascade
  add_foreign_key "op_exam_op_faculty_rel", "op_faculty", name: "op_exam_op_faculty_rel_op_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "op_exam_room", "op_classroom", column: "classroom_id", name: "op_exam_room_classroom_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam_room", "res_users", column: "create_uid", name: "op_exam_room_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam_room", "res_users", column: "write_uid", name: "op_exam_room_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam_room_op_room_distribution_rel", "op_exam_room", name: "op_exam_room_op_room_distribution_rel_op_exam_room_id_fkey", on_delete: :cascade
  add_foreign_key "op_exam_room_op_room_distribution_rel", "op_room_distribution", name: "op_exam_room_op_room_distribution__op_room_distribution_id_fkey", on_delete: :cascade
  add_foreign_key "op_exam_session", "op_batch", column: "batch_id", name: "op_exam_session_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam_session", "op_course", column: "course_id", name: "op_exam_session_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_exam_session", "op_exam_type", column: "exam_type", name: "op_exam_session_exam_type_fkey", on_delete: :nullify
  add_foreign_key "op_exam_session", "res_partner", column: "venue", name: "op_exam_session_venue_fkey", on_delete: :nullify
  add_foreign_key "op_exam_session", "res_users", column: "create_uid", name: "op_exam_session_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam_session", "res_users", column: "write_uid", name: "op_exam_session_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam_type", "res_users", column: "create_uid", name: "op_exam_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_exam_type", "res_users", column: "write_uid", name: "op_exam_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_facility", "res_users", column: "create_uid", name: "op_facility_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_facility", "res_users", column: "write_uid", name: "op_facility_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_facility_line", "op_classroom", column: "classroom_id", name: "op_facility_line_classroom_id_fkey", on_delete: :nullify
  add_foreign_key "op_facility_line", "op_facility", column: "facility_id", name: "op_facility_line_facility_id_fkey", on_delete: :nullify
  add_foreign_key "op_facility_line", "res_users", column: "create_uid", name: "op_facility_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_facility_line", "res_users", column: "write_uid", name: "op_facility_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_faculty", "hr_employee", column: "emp_id", name: "op_faculty_emp_id_fkey", on_delete: :nullify
  add_foreign_key "op_faculty", "op_library_card", column: "library_card_id", name: "op_faculty_library_card_id_fkey", on_delete: :nullify
  add_foreign_key "op_faculty", "res_company", column: "company_id", name: "op_faculty_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_faculty", "res_country", column: "nationality", name: "op_faculty_nationality_fkey", on_delete: :nullify
  add_foreign_key "op_faculty", "res_partner", column: "emergency_contact", name: "op_faculty_emergency_contact_fkey", on_delete: :nullify
  add_foreign_key "op_faculty", "res_partner", column: "partner_id", name: "op_faculty_partner_id_fkey", on_delete: :cascade
  add_foreign_key "op_faculty", "res_users", column: "create_uid", name: "op_faculty_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_faculty", "res_users", column: "related_user", name: "op_faculty_related_user_fkey", on_delete: :nullify
  add_foreign_key "op_faculty", "res_users", column: "write_uid", name: "op_faculty_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_faculty_op_subject_rel", "op_faculty", name: "op_faculty_op_subject_rel_op_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "op_faculty_op_subject_rel", "op_subject", name: "op_faculty_op_subject_rel_op_subject_id_fkey", on_delete: :cascade
  add_foreign_key "op_faculty_wizard_merge_faculty_rel", "op_faculty", name: "op_faculty_wizard_merge_faculty_rel_op_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "op_faculty_wizard_merge_faculty_rel", "wizard_merge_faculty", name: "op_faculty_wizard_merge_faculty_re_wizard_merge_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "op_faculty_wizard_op_faculty_rel", "op_faculty", name: "op_faculty_wizard_op_faculty_rel_op_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "op_faculty_wizard_op_faculty_rel", "wizard_op_faculty", name: "op_faculty_wizard_op_faculty_rel_wizard_op_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "op_fees_terms", "res_company", column: "company_id", name: "op_fees_terms_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_fees_terms", "res_users", column: "create_uid", name: "op_fees_terms_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_fees_terms", "res_users", column: "write_uid", name: "op_fees_terms_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_fees_terms_line", "op_fees_terms", column: "fees_id", name: "op_fees_terms_line_fees_id_fkey", on_delete: :nullify
  add_foreign_key "op_fees_terms_line", "res_users", column: "create_uid", name: "op_fees_terms_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_fees_terms_line", "res_users", column: "write_uid", name: "op_fees_terms_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_gamification_badge", "res_users", column: "create_uid", name: "op_gamification_badge_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_gamification_badge", "res_users", column: "write_uid", name: "op_gamification_badge_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_grade_configuration", "res_users", column: "create_uid", name: "op_grade_configuration_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_grade_configuration", "res_users", column: "write_uid", name: "op_grade_configuration_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_grade_configuration_op_result_template_rel", "op_grade_configuration", name: "op_grade_configuration_op_result_op_grade_configuration_id_fkey", on_delete: :cascade
  add_foreign_key "op_grade_configuration_op_result_template_rel", "op_result_template", name: "op_grade_configuration_op_result_tem_op_result_template_id_fkey", on_delete: :cascade
  add_foreign_key "op_held_exam", "op_batch", column: "batch_id", name: "op_held_exam_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_held_exam", "op_course", column: "course_id", name: "op_held_exam_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_held_exam", "op_exam", column: "exam_id", name: "op_held_exam_exam_id_fkey", on_delete: :nullify
  add_foreign_key "op_held_exam", "op_subject", column: "subject_id", name: "op_held_exam_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_held_exam", "res_users", column: "create_uid", name: "op_held_exam_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_held_exam", "res_users", column: "write_uid", name: "op_held_exam_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_lession", "op_subject", column: "subject_id", name: "op_lession_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_lession", "res_users", column: "create_uid", name: "op_lession_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_lession", "res_users", column: "write_uid", name: "op_lession_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_library_card", "op_faculty", column: "faculty_id", name: "op_library_card_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "op_library_card", "op_library_card_type", column: "library_card_type_id", name: "op_library_card_library_card_type_id_fkey", on_delete: :nullify
  add_foreign_key "op_library_card", "op_student", column: "student_id", name: "op_library_card_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_library_card", "res_partner", column: "partner_id", name: "op_library_card_partner_id_fkey", on_delete: :nullify
  add_foreign_key "op_library_card", "res_users", column: "create_uid", name: "op_library_card_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_library_card", "res_users", column: "write_uid", name: "op_library_card_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_library_card_type", "res_users", column: "create_uid", name: "op_library_card_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_library_card_type", "res_users", column: "write_uid", name: "op_library_card_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_line", "op_marksheet_register", column: "marksheet_reg_id", name: "op_marksheet_line_marksheet_reg_id_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_line", "op_student", column: "student_id", name: "op_marksheet_line_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_line", "res_users", column: "create_uid", name: "op_marksheet_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_line", "res_users", column: "write_uid", name: "op_marksheet_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_register", "op_exam_session", column: "exam_session_id", name: "op_marksheet_register_exam_session_id_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_register", "op_result_template", column: "result_template_id", name: "op_marksheet_register_result_template_id_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_register", "res_users", column: "create_uid", name: "op_marksheet_register_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_register", "res_users", column: "generated_by", name: "op_marksheet_register_generated_by_fkey", on_delete: :nullify
  add_foreign_key "op_marksheet_register", "res_users", column: "write_uid", name: "op_marksheet_register_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media", "op_media_type", column: "media_type_id", name: "op_media_media_type_id_fkey", on_delete: :nullify
  add_foreign_key "op_media", "res_company", column: "company_id", name: "op_media_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_media", "res_users", column: "create_uid", name: "op_media_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media", "res_users", column: "write_uid", name: "op_media_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "account_invoice", column: "invoice_id", name: "op_media_movement_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "hr_employee", column: "employee_id", name: "op_media_movement_employee_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "hr_employee", column: "manager_id", name: "op_media_movement_manager_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "op_faculty", column: "faculty_id", name: "op_media_movement_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "op_library_card", column: "library_card_id", name: "op_media_movement_library_card_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "op_media", column: "media_id", name: "op_media_movement_media_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "op_media_type", column: "media_type_id", name: "op_media_movement_media_type_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "op_media_unit", column: "media_unit_id", name: "op_media_movement_media_unit_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "op_student", column: "student_id", name: "op_media_movement_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "res_partner", column: "partner_id", name: "op_media_movement_partner_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "res_users", column: "create_uid", name: "op_media_movement_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_movement", "res_users", column: "write_uid", name: "op_media_movement_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_op_publisher_rel", "op_media", column: "op_media_id", name: "op_media_op_publisher_rel_op_media_id_fkey", on_delete: :cascade
  add_foreign_key "op_media_op_publisher_rel", "op_publisher", name: "op_media_op_publisher_rel_op_publisher_id_fkey", on_delete: :cascade
  add_foreign_key "op_media_op_subject_rel", "op_media", column: "op_media_id", name: "op_media_op_subject_rel_op_media_id_fkey", on_delete: :cascade
  add_foreign_key "op_media_op_subject_rel", "op_subject", name: "op_media_op_subject_rel_op_subject_id_fkey", on_delete: :cascade
  add_foreign_key "op_media_op_tag_rel", "op_media", column: "op_media_id", name: "op_media_op_tag_rel_op_media_id_fkey", on_delete: :cascade
  add_foreign_key "op_media_op_tag_rel", "op_tag", name: "op_media_op_tag_rel_op_tag_id_fkey", on_delete: :cascade
  add_foreign_key "op_media_purchase", "op_course", column: "course_ids", name: "op_media_purchase_course_ids_fkey", on_delete: :nullify
  add_foreign_key "op_media_purchase", "op_media_type", column: "media_type_id", name: "op_media_purchase_media_type_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_purchase", "op_subject", column: "subject_ids", name: "op_media_purchase_subject_ids_fkey", on_delete: :nullify
  add_foreign_key "op_media_purchase", "res_partner", column: "requested_id", name: "op_media_purchase_requested_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_purchase", "res_users", column: "create_uid", name: "op_media_purchase_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_purchase", "res_users", column: "write_uid", name: "op_media_purchase_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_queue", "op_media", column: "media_id", name: "op_media_queue_media_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_queue", "res_partner", column: "partner_id", name: "op_media_queue_partner_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_queue", "res_users", column: "create_uid", name: "op_media_queue_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_queue", "res_users", column: "user_id", name: "op_media_queue_user_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_queue", "res_users", column: "write_uid", name: "op_media_queue_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_type", "res_users", column: "create_uid", name: "op_media_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_type", "res_users", column: "write_uid", name: "op_media_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_unit", "op_media", column: "media_id", name: "op_media_unit_media_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_unit", "op_media_type", column: "media_type_id", name: "op_media_unit_media_type_id_fkey", on_delete: :nullify
  add_foreign_key "op_media_unit", "res_users", column: "create_uid", name: "op_media_unit_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_media_unit", "res_users", column: "write_uid", name: "op_media_unit_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_parent", "res_partner", column: "name", name: "op_parent_name_fkey", on_delete: :nullify
  add_foreign_key "op_parent", "res_users", column: "create_uid", name: "op_parent_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_parent", "res_users", column: "user_id", name: "op_parent_user_id_fkey", on_delete: :nullify
  add_foreign_key "op_parent", "res_users", column: "write_uid", name: "op_parent_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_parent_op_student_rel", "op_parent", name: "op_parent_op_student_rel_op_parent_id_fkey", on_delete: :cascade
  add_foreign_key "op_parent_op_student_rel", "op_student", name: "op_parent_op_student_rel_op_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_publisher", "res_partner", column: "address_id", name: "op_publisher_address_id_fkey", on_delete: :nullify
  add_foreign_key "op_publisher", "res_users", column: "create_uid", name: "op_publisher_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_publisher", "res_users", column: "write_uid", name: "op_publisher_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_result_line", "op_exam", column: "exam_id", name: "op_result_line_exam_id_fkey", on_delete: :nullify
  add_foreign_key "op_result_line", "op_marksheet_line", column: "marksheet_line_id", name: "op_result_line_marksheet_line_id_fkey", on_delete: :cascade
  add_foreign_key "op_result_line", "op_student", column: "student_id", name: "op_result_line_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_result_line", "res_users", column: "create_uid", name: "op_result_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_result_line", "res_users", column: "write_uid", name: "op_result_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_result_template", "op_exam_session", column: "exam_session_id", name: "op_result_template_exam_session_id_fkey", on_delete: :nullify
  add_foreign_key "op_result_template", "res_users", column: "create_uid", name: "op_result_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_result_template", "res_users", column: "write_uid", name: "op_result_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_room_distribution", "op_batch", column: "batch_id", name: "op_room_distribution_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_room_distribution", "op_course", column: "course_id", name: "op_room_distribution_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_room_distribution", "op_exam", column: "exam_id", name: "op_room_distribution_exam_id_fkey", on_delete: :nullify
  add_foreign_key "op_room_distribution", "op_exam_session", column: "exam_session", name: "op_room_distribution_exam_session_fkey", on_delete: :nullify
  add_foreign_key "op_room_distribution", "op_subject", column: "subject_id", name: "op_room_distribution_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_room_distribution", "res_users", column: "create_uid", name: "op_room_distribution_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_room_distribution", "res_users", column: "write_uid", name: "op_room_distribution_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_room_distribution_op_student_rel", "op_room_distribution", name: "op_room_distribution_op_student_re_op_room_distribution_id_fkey", on_delete: :cascade
  add_foreign_key "op_room_distribution_op_student_rel", "op_student", name: "op_room_distribution_op_student_rel_op_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_session", "course_categ", column: "course_categ", name: "op_session_course_categ_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_batch", column: "batch_id", name: "op_session_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_classroom", column: "classroom_id", name: "op_session_classroom_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_course", column: "course_id", name: "op_session_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_faculty", column: "assessor", name: "op_session_assessor_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_faculty", column: "faculty_id", name: "op_session_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_faculty", column: "observe_faculty", name: "op_session_observe_faculty_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_lession", column: "lession_id", name: "op_session_lession_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_student_course", column: "student_course_id", name: "op_session_student_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_subject", column: "subject_id", name: "op_session_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "op_timing", column: "timing_id", name: "op_session_timing_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "res_company", column: "company_id", name: "op_session_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "res_users", column: "create_uid", name: "op_session_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_session", "res_users", column: "user_id", name: "op_session_user_id_fkey", on_delete: :nullify
  add_foreign_key "op_session", "res_users", column: "write_uid", name: "op_session_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_session_change_faculty", "op_batch", column: "batch_id", name: "op_session_change_faculty_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_change_faculty", "op_course", column: "course_id", name: "op_session_change_faculty_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_change_faculty", "op_faculty", column: "faculty_id", name: "op_session_change_faculty_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_change_faculty", "op_subject", column: "subject_id", name: "op_session_change_faculty_subject_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_change_faculty", "res_users", column: "create_uid", name: "op_session_change_faculty_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_session_change_faculty", "res_users", column: "write_uid", name: "op_session_change_faculty_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_session_offset_student", "op_session", column: "session_id", name: "op_session_offset_student_session_id_fkey", on_delete: :cascade
  add_foreign_key "op_session_offset_student", "op_student", column: "student_id", name: "op_session_offset_student_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_session_res_users_rel", "op_session", name: "op_session_res_users_rel_op_session_id_fkey", on_delete: :cascade
  add_foreign_key "op_session_res_users_rel", "res_users", column: "res_users_id", name: "op_session_res_users_rel_res_users_id_fkey", on_delete: :cascade
  add_foreign_key "op_session_student", "op_batch", column: "batch_id", name: "op_session_student_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_student", "op_classroom", column: "classroom_id", name: "op_session_student_classroom_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_student", "op_session", column: "session_id", name: "op_session_student_session_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_student", "op_student_course", column: "student_course_id", name: "op_session_student_student_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_student", "res_company", column: "company_id", name: "op_session_student_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_session_student", "res_users", column: "create_uid", name: "op_session_student_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_session_student", "res_users", column: "write_uid", name: "op_session_student_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student", "op_batch", column: "batch_id", name: "op_student_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_student", "op_category", column: "category_id", name: "op_student_category_id_fkey", on_delete: :nullify
  add_foreign_key "op_student", "op_course", column: "course_id", name: "op_student_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_student", "op_library_card", column: "library_card_id", name: "op_student_library_card_id_fkey", on_delete: :nullify
  add_foreign_key "op_student", "res_company", column: "company_id", name: "op_student_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_student", "res_country", column: "nationality", name: "op_student_nationality_fkey", on_delete: :nullify
  add_foreign_key "op_student", "res_partner", column: "emergency_contact", name: "op_student_emergency_contact_fkey", on_delete: :nullify
  add_foreign_key "op_student", "res_partner", column: "parent_id", name: "op_student_parent_id_fkey", on_delete: :nullify
  add_foreign_key "op_student", "res_partner", column: "partner_id", name: "op_student_partner_id_fkey", on_delete: :cascade
  add_foreign_key "op_student", "res_users", column: "create_uid", name: "op_student_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student", "res_users", column: "write_uid", name: "op_student_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student_attendance_report", "op_batch", column: "batch_id", name: "op_student_attendance_report_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_attendance_report", "op_course", column: "course_id", name: "op_student_attendance_report_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_attendance_report", "op_student", column: "student_id", name: "op_student_attendance_report_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_attendance_report", "res_company", column: "company_id", name: "op_student_attendance_report_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_attendance_report", "res_users", column: "create_uid", name: "op_student_attendance_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student_attendance_report", "res_users", column: "write_uid", name: "op_student_attendance_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student_course", "course_categ", column: "categ_id", name: "op_student_course_categ_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_course", "op_batch", column: "batch_id", name: "op_student_course_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_course", "op_course", column: "course_id", name: "op_student_course_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_course", "op_student", column: "student_id", name: "op_student_course_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_student_course", "res_company", column: "company_id", name: "op_student_course_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_course", "res_users", column: "create_uid", name: "op_student_course_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student_course", "res_users", column: "write_uid", name: "op_student_course_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student_course_op_subject_rel", "op_student_course", name: "op_student_course_op_subject_rel_op_student_course_id_fkey", on_delete: :cascade
  add_foreign_key "op_student_course_op_subject_rel", "op_subject", name: "op_student_course_op_subject_rel_op_subject_id_fkey", on_delete: :cascade
  add_foreign_key "op_student_fees_details", "account_invoice", column: "invoice_id", name: "op_student_fees_details_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_fees_details", "op_fees_terms_line", column: "fees_line_id", name: "op_student_fees_details_fees_line_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_fees_details", "op_student", column: "student_id", name: "op_student_fees_details_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_fees_details", "product_product", column: "product_id", name: "op_student_fees_details_product_id_fkey", on_delete: :nullify
  add_foreign_key "op_student_fees_details", "res_users", column: "create_uid", name: "op_student_fees_details_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student_fees_details", "res_users", column: "write_uid", name: "op_student_fees_details_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_student_student_migrate_rel", "op_student", name: "op_student_student_migrate_rel_op_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_student_student_migrate_rel", "student_migrate", name: "op_student_student_migrate_rel_student_migrate_id_fkey", on_delete: :cascade
  add_foreign_key "op_student_wizard_op_student_rel", "op_student", name: "op_student_wizard_op_student_rel_op_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_student_wizard_op_student_rel", "wizard_op_student", name: "op_student_wizard_op_student_rel_wizard_op_student_id_fkey", on_delete: :cascade
  add_foreign_key "op_subject", "op_course", column: "course_id", name: "op_subject_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_subject", "res_company", column: "company_id", name: "op_subject_company_id_fkey", on_delete: :nullify
  add_foreign_key "op_subject", "res_users", column: "create_uid", name: "op_subject_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_subject", "res_users", column: "write_uid", name: "op_subject_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_subject_op_subject_registration_rel", "op_subject", name: "op_subject_op_subject_registration_rel_op_subject_id_fkey", on_delete: :cascade
  add_foreign_key "op_subject_op_subject_registration_rel", "op_subject_registration", name: "op_subject_op_subject_registrat_op_subject_registration_id_fkey", on_delete: :cascade
  add_foreign_key "op_subject_registration", "op_batch", column: "batch_id", name: "op_subject_registration_batch_id_fkey", on_delete: :nullify
  add_foreign_key "op_subject_registration", "op_course", column: "course_id", name: "op_subject_registration_course_id_fkey", on_delete: :nullify
  add_foreign_key "op_subject_registration", "op_student", column: "student_id", name: "op_subject_registration_student_id_fkey", on_delete: :nullify
  add_foreign_key "op_subject_registration", "res_users", column: "create_uid", name: "op_subject_registration_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_subject_registration", "res_users", column: "write_uid", name: "op_subject_registration_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_tag", "res_users", column: "create_uid", name: "op_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_tag", "res_users", column: "write_uid", name: "op_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "op_timing", "res_users", column: "create_uid", name: "op_timing_create_uid_fkey", on_delete: :nullify
  add_foreign_key "op_timing", "res_users", column: "write_uid", name: "op_timing_write_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_acquirer", "account_journal", column: "journal_id", name: "payment_acquirer_journal_id_fkey", on_delete: :nullify
  add_foreign_key "payment_acquirer", "ir_module_module", column: "module_id", name: "payment_acquirer_module_id_fkey", on_delete: :nullify
  add_foreign_key "payment_acquirer", "ir_ui_view", column: "registration_view_template_id", name: "payment_acquirer_registration_view_template_id_fkey", on_delete: :nullify
  add_foreign_key "payment_acquirer", "ir_ui_view", column: "view_template_id", name: "payment_acquirer_view_template_id_fkey", on_delete: :nullify
  add_foreign_key "payment_acquirer", "res_company", column: "company_id", name: "payment_acquirer_company_id_fkey", on_delete: :nullify
  add_foreign_key "payment_acquirer", "res_users", column: "create_uid", name: "payment_acquirer_create_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_acquirer", "res_users", column: "write_uid", name: "payment_acquirer_write_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_acquirer_payment_icon_rel", "payment_acquirer", name: "payment_acquirer_payment_icon_rel_payment_acquirer_id_fkey", on_delete: :cascade
  add_foreign_key "payment_acquirer_payment_icon_rel", "payment_icon", name: "payment_acquirer_payment_icon_rel_payment_icon_id_fkey", on_delete: :cascade
  add_foreign_key "payment_country_rel", "payment_acquirer", column: "payment_id", name: "payment_country_rel_payment_id_fkey", on_delete: :cascade
  add_foreign_key "payment_country_rel", "res_country", column: "country_id", name: "payment_country_rel_country_id_fkey", on_delete: :cascade
  add_foreign_key "payment_icon", "res_users", column: "create_uid", name: "payment_icon_create_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_icon", "res_users", column: "write_uid", name: "payment_icon_write_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_token", "payment_acquirer", column: "acquirer_id", name: "payment_token_acquirer_id_fkey", on_delete: :nullify
  add_foreign_key "payment_token", "res_partner", column: "partner_id", name: "payment_token_partner_id_fkey", on_delete: :nullify
  add_foreign_key "payment_token", "res_users", column: "create_uid", name: "payment_token_create_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_token", "res_users", column: "write_uid", name: "payment_token_write_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "account_invoice", name: "payment_transaction_account_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "ir_model", column: "callback_model_id", name: "payment_transaction_callback_model_id_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "payment_acquirer", column: "acquirer_id", name: "payment_transaction_acquirer_id_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "payment_token", name: "payment_transaction_payment_token_id_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "res_country", column: "partner_country_id", name: "payment_transaction_partner_country_id_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "res_currency", column: "currency_id", name: "payment_transaction_currency_id_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "res_partner", column: "partner_id", name: "payment_transaction_partner_id_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "res_users", column: "create_uid", name: "payment_transaction_create_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "res_users", column: "write_uid", name: "payment_transaction_write_uid_fkey", on_delete: :nullify
  add_foreign_key "payment_transaction", "sale_order", name: "payment_transaction_sale_order_id_fkey", on_delete: :nullify
  add_foreign_key "payslip_lines_contribution_register", "res_users", column: "create_uid", name: "payslip_lines_contribution_register_create_uid_fkey", on_delete: :nullify
  add_foreign_key "payslip_lines_contribution_register", "res_users", column: "write_uid", name: "payslip_lines_contribution_register_write_uid_fkey", on_delete: :nullify
  add_foreign_key "portal_wizard", "res_groups", column: "portal_id", name: "portal_wizard_portal_id_fkey", on_delete: :nullify
  add_foreign_key "portal_wizard", "res_users", column: "create_uid", name: "portal_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "portal_wizard", "res_users", column: "write_uid", name: "portal_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "portal_wizard_user", "portal_wizard", column: "wizard_id", name: "portal_wizard_user_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "portal_wizard_user", "res_partner", column: "partner_id", name: "portal_wizard_user_partner_id_fkey", on_delete: :cascade
  add_foreign_key "portal_wizard_user", "res_users", column: "create_uid", name: "portal_wizard_user_create_uid_fkey", on_delete: :nullify
  add_foreign_key "portal_wizard_user", "res_users", column: "user_id", name: "portal_wizard_user_user_id_fkey", on_delete: :nullify
  add_foreign_key "portal_wizard_user", "res_users", column: "write_uid", name: "portal_wizard_user_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_category", "pos_category", column: "parent_id", name: "pos_category_parent_id_fkey", on_delete: :nullify
  add_foreign_key "pos_category", "res_users", column: "create_uid", name: "pos_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_category", "res_users", column: "write_uid", name: "pos_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "account_fiscal_position", column: "default_fiscal_position_id", name: "pos_config_default_fiscal_position_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "account_journal", column: "invoice_journal_id", name: "pos_config_invoice_journal_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "account_journal", column: "journal_id", name: "pos_config_journal_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "barcode_nomenclature", name: "pos_config_barcode_nomenclature_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "ir_sequence", column: "sequence_id", name: "pos_config_sequence_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "ir_sequence", column: "sequence_line_id", name: "pos_config_sequence_line_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "pos_category", column: "iface_start_categ_id", name: "pos_config_iface_start_categ_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "product_pricelist", column: "pricelist_id", name: "pos_config_pricelist_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "product_product", column: "tip_product_id", name: "pos_config_tip_product_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "res_company", column: "company_id", name: "pos_config_company_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "res_groups", column: "group_pos_manager_id", name: "pos_config_group_pos_manager_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "res_groups", column: "group_pos_user_id", name: "pos_config_group_pos_user_id_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "res_users", column: "create_uid", name: "pos_config_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_config", "res_users", column: "write_uid", name: "pos_config_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_config_journal_rel", "account_journal", column: "journal_id", name: "pos_config_journal_rel_journal_id_fkey", on_delete: :cascade
  add_foreign_key "pos_config_journal_rel", "pos_config", name: "pos_config_journal_rel_pos_config_id_fkey", on_delete: :cascade
  add_foreign_key "pos_config_product_pricelist_rel", "pos_config", name: "pos_config_product_pricelist_rel_pos_config_id_fkey", on_delete: :cascade
  add_foreign_key "pos_config_product_pricelist_rel", "product_pricelist", name: "pos_config_product_pricelist_rel_product_pricelist_id_fkey", on_delete: :cascade
  add_foreign_key "pos_detail_configs", "pos_config", name: "pos_detail_configs_pos_config_id_fkey", on_delete: :cascade
  add_foreign_key "pos_detail_configs", "pos_details_wizard", name: "pos_detail_configs_pos_details_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "pos_details_wizard", "res_users", column: "create_uid", name: "pos_details_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_details_wizard", "res_users", column: "write_uid", name: "pos_details_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_discount", "res_users", column: "create_uid", name: "pos_discount_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_discount", "res_users", column: "write_uid", name: "pos_discount_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_make_payment", "account_journal", column: "journal_id", name: "pos_make_payment_journal_id_fkey", on_delete: :nullify
  add_foreign_key "pos_make_payment", "pos_session", column: "session_id", name: "pos_make_payment_session_id_fkey", on_delete: :nullify
  add_foreign_key "pos_make_payment", "res_users", column: "create_uid", name: "pos_make_payment_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_make_payment", "res_users", column: "write_uid", name: "pos_make_payment_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_open_statement", "res_users", column: "create_uid", name: "pos_open_statement_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_open_statement", "res_users", column: "write_uid", name: "pos_open_statement_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "account_fiscal_position", column: "fiscal_position_id", name: "pos_order_fiscal_position_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "account_invoice", column: "invoice_id", name: "pos_order_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "account_journal", column: "sale_journal", name: "pos_order_sale_journal_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "account_move", column: "account_move", name: "pos_order_account_move_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "pos_session", column: "session_id", name: "pos_order_session_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "product_pricelist", column: "pricelist_id", name: "pos_order_pricelist_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "res_company", column: "company_id", name: "pos_order_company_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "res_partner", column: "partner_id", name: "pos_order_partner_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "res_users", column: "create_uid", name: "pos_order_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "res_users", column: "user_id", name: "pos_order_user_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order", "res_users", column: "write_uid", name: "pos_order_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_order_line", "pos_order", column: "order_id", name: "pos_order_line_order_id_fkey", on_delete: :cascade
  add_foreign_key "pos_order_line", "product_product", column: "product_id", name: "pos_order_line_product_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order_line", "res_company", column: "company_id", name: "pos_order_line_company_id_fkey", on_delete: :nullify
  add_foreign_key "pos_order_line", "res_users", column: "create_uid", name: "pos_order_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_order_line", "res_users", column: "write_uid", name: "pos_order_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_pack_operation_lot", "pos_order_line", name: "pos_pack_operation_lot_pos_order_line_id_fkey", on_delete: :nullify
  add_foreign_key "pos_pack_operation_lot", "res_users", column: "create_uid", name: "pos_pack_operation_lot_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_pack_operation_lot", "res_users", column: "write_uid", name: "pos_pack_operation_lot_write_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_session", "account_bank_statement", column: "cash_register_id", name: "pos_session_cash_register_id_fkey", on_delete: :nullify
  add_foreign_key "pos_session", "account_journal", column: "cash_journal_id", name: "pos_session_cash_journal_id_fkey", on_delete: :nullify
  add_foreign_key "pos_session", "pos_config", column: "config_id", name: "pos_session_config_id_fkey", on_delete: :nullify
  add_foreign_key "pos_session", "res_users", column: "create_uid", name: "pos_session_create_uid_fkey", on_delete: :nullify
  add_foreign_key "pos_session", "res_users", column: "user_id", name: "pos_session_user_id_fkey", on_delete: :nullify
  add_foreign_key "pos_session", "res_users", column: "write_uid", name: "pos_session_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute", "res_users", column: "create_uid", name: "product_attribute_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute", "res_users", column: "write_uid", name: "product_attribute_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute_line", "product_attribute", column: "attribute_id", name: "product_attribute_line_attribute_id_fkey", on_delete: :restrict
  add_foreign_key "product_attribute_line", "product_template", column: "product_tmpl_id", name: "product_attribute_line_product_tmpl_id_fkey", on_delete: :cascade
  add_foreign_key "product_attribute_line", "res_users", column: "create_uid", name: "product_attribute_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute_line", "res_users", column: "write_uid", name: "product_attribute_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute_line_product_attribute_value_rel", "product_attribute_line", name: "product_attribute_line_product_a_product_attribute_line_id_fkey", on_delete: :cascade
  add_foreign_key "product_attribute_line_product_attribute_value_rel", "product_attribute_value", name: "product_attribute_line_product__product_attribute_value_id_fkey", on_delete: :cascade
  add_foreign_key "product_attribute_price", "product_attribute_value", column: "value_id", name: "product_attribute_price_value_id_fkey", on_delete: :cascade
  add_foreign_key "product_attribute_price", "product_template", column: "product_tmpl_id", name: "product_attribute_price_product_tmpl_id_fkey", on_delete: :cascade
  add_foreign_key "product_attribute_price", "res_users", column: "create_uid", name: "product_attribute_price_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute_price", "res_users", column: "write_uid", name: "product_attribute_price_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute_value", "product_attribute", column: "attribute_id", name: "product_attribute_value_attribute_id_fkey", on_delete: :cascade
  add_foreign_key "product_attribute_value", "res_users", column: "create_uid", name: "product_attribute_value_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute_value", "res_users", column: "write_uid", name: "product_attribute_value_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_attribute_value_product_product_rel", "product_attribute_value", name: "product_attribute_value_product_product_attribute_value_id_fkey", on_delete: :cascade
  add_foreign_key "product_attribute_value_product_product_rel", "product_product", name: "product_attribute_value_product_product_product_product_id_fkey", on_delete: :cascade
  add_foreign_key "product_category", "product_category", column: "parent_id", name: "product_category_parent_id_fkey", on_delete: :cascade
  add_foreign_key "product_category", "res_users", column: "create_uid", name: "product_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_category", "res_users", column: "write_uid", name: "product_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_margin", "res_users", column: "create_uid", name: "product_margin_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_margin", "res_users", column: "write_uid", name: "product_margin_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_packaging", "product_product", column: "product_id", name: "product_packaging_product_id_fkey", on_delete: :nullify
  add_foreign_key "product_packaging", "res_users", column: "create_uid", name: "product_packaging_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_packaging", "res_users", column: "write_uid", name: "product_packaging_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_price_history", "product_product", column: "product_id", name: "product_price_history_product_id_fkey", on_delete: :cascade
  add_foreign_key "product_price_history", "res_company", column: "company_id", name: "product_price_history_company_id_fkey", on_delete: :nullify
  add_foreign_key "product_price_history", "res_users", column: "create_uid", name: "product_price_history_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_price_history", "res_users", column: "write_uid", name: "product_price_history_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_price_list", "product_pricelist", column: "price_list", name: "product_price_list_price_list_fkey", on_delete: :nullify
  add_foreign_key "product_price_list", "res_users", column: "create_uid", name: "product_price_list_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_price_list", "res_users", column: "write_uid", name: "product_price_list_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist", "res_company", column: "company_id", name: "product_pricelist_company_id_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist", "res_currency", column: "currency_id", name: "product_pricelist_currency_id_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist", "res_users", column: "create_uid", name: "product_pricelist_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist", "res_users", column: "write_uid", name: "product_pricelist_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist_item", "product_category", column: "categ_id", name: "product_pricelist_item_categ_id_fkey", on_delete: :cascade
  add_foreign_key "product_pricelist_item", "product_pricelist", column: "base_pricelist_id", name: "product_pricelist_item_base_pricelist_id_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist_item", "product_pricelist", column: "pricelist_id", name: "product_pricelist_item_pricelist_id_fkey", on_delete: :cascade
  add_foreign_key "product_pricelist_item", "product_product", column: "product_id", name: "product_pricelist_item_product_id_fkey", on_delete: :cascade
  add_foreign_key "product_pricelist_item", "product_template", column: "product_tmpl_id", name: "product_pricelist_item_product_tmpl_id_fkey", on_delete: :cascade
  add_foreign_key "product_pricelist_item", "res_company", column: "company_id", name: "product_pricelist_item_company_id_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist_item", "res_currency", column: "currency_id", name: "product_pricelist_item_currency_id_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist_item", "res_users", column: "create_uid", name: "product_pricelist_item_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_pricelist_item", "res_users", column: "write_uid", name: "product_pricelist_item_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_product", "product_template", column: "product_tmpl_id", name: "product_product_product_tmpl_id_fkey", on_delete: :cascade
  add_foreign_key "product_product", "res_users", column: "create_uid", name: "product_product_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_product", "res_users", column: "write_uid", name: "product_product_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_supplier_taxes_rel", "account_tax", column: "tax_id", name: "product_supplier_taxes_rel_tax_id_fkey", on_delete: :cascade
  add_foreign_key "product_supplier_taxes_rel", "product_template", column: "prod_id", name: "product_supplier_taxes_rel_prod_id_fkey", on_delete: :cascade
  add_foreign_key "product_supplierinfo", "product_product", column: "product_id", name: "product_supplierinfo_product_id_fkey", on_delete: :nullify
  add_foreign_key "product_supplierinfo", "product_template", column: "product_tmpl_id", name: "product_supplierinfo_product_tmpl_id_fkey", on_delete: :cascade
  add_foreign_key "product_supplierinfo", "res_company", column: "company_id", name: "product_supplierinfo_company_id_fkey", on_delete: :nullify
  add_foreign_key "product_supplierinfo", "res_currency", column: "currency_id", name: "product_supplierinfo_currency_id_fkey", on_delete: :nullify
  add_foreign_key "product_supplierinfo", "res_partner", column: "name", name: "product_supplierinfo_name_fkey", on_delete: :cascade
  add_foreign_key "product_supplierinfo", "res_users", column: "create_uid", name: "product_supplierinfo_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_supplierinfo", "res_users", column: "write_uid", name: "product_supplierinfo_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_taxes_rel", "account_tax", column: "tax_id", name: "product_taxes_rel_tax_id_fkey", on_delete: :cascade
  add_foreign_key "product_taxes_rel", "product_template", column: "prod_id", name: "product_taxes_rel_prod_id_fkey", on_delete: :cascade
  add_foreign_key "product_template", "mail_template", column: "email_template_id", name: "product_template_email_template_id_fkey", on_delete: :nullify
  add_foreign_key "product_template", "pos_category", column: "pos_categ_id", name: "product_template_pos_categ_id_fkey", on_delete: :nullify
  add_foreign_key "product_template", "product_category", column: "categ_id", name: "product_template_categ_id_fkey", on_delete: :nullify
  add_foreign_key "product_template", "product_uom", column: "uom_id", name: "product_template_uom_id_fkey", on_delete: :nullify
  add_foreign_key "product_template", "product_uom", column: "uom_po_id", name: "product_template_uom_po_id_fkey", on_delete: :nullify
  add_foreign_key "product_template", "res_company", column: "company_id", name: "product_template_company_id_fkey", on_delete: :nullify
  add_foreign_key "product_template", "res_users", column: "create_uid", name: "product_template_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_template", "res_users", column: "write_uid", name: "product_template_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_uom", "product_uom_categ", column: "category_id", name: "product_uom_category_id_fkey", on_delete: :cascade
  add_foreign_key "product_uom", "res_users", column: "create_uid", name: "product_uom_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_uom", "res_users", column: "write_uid", name: "product_uom_write_uid_fkey", on_delete: :nullify
  add_foreign_key "product_uom_categ", "res_users", column: "create_uid", name: "product_uom_categ_create_uid_fkey", on_delete: :nullify
  add_foreign_key "product_uom_categ", "res_users", column: "write_uid", name: "product_uom_categ_write_uid_fkey", on_delete: :nullify
  add_foreign_key "project_favorite_user_rel", "project_project", column: "project_id", name: "project_favorite_user_rel_project_id_fkey", on_delete: :cascade
  add_foreign_key "project_favorite_user_rel", "res_users", column: "user_id", name: "project_favorite_user_rel_user_id_fkey", on_delete: :cascade
  add_foreign_key "project_project", "account_analytic_account", column: "analytic_account_id", name: "project_project_analytic_account_id_fkey", on_delete: :cascade
  add_foreign_key "project_project", "mail_alias", column: "alias_id", name: "project_project_alias_id_fkey", on_delete: :restrict
  add_foreign_key "project_project", "project_project", column: "subtask_project_id", name: "project_project_subtask_project_id_fkey", on_delete: :restrict
  add_foreign_key "project_project", "res_users", column: "create_uid", name: "project_project_create_uid_fkey", on_delete: :nullify
  add_foreign_key "project_project", "res_users", column: "user_id", name: "project_project_user_id_fkey", on_delete: :nullify
  add_foreign_key "project_project", "res_users", column: "write_uid", name: "project_project_write_uid_fkey", on_delete: :nullify
  add_foreign_key "project_project", "resource_calendar", name: "project_project_resource_calendar_id_fkey", on_delete: :nullify
  add_foreign_key "project_project", "sale_order_line", column: "sale_line_id", name: "project_project_sale_line_id_fkey", on_delete: :nullify
  add_foreign_key "project_tags", "res_users", column: "create_uid", name: "project_tags_create_uid_fkey", on_delete: :nullify
  add_foreign_key "project_tags", "res_users", column: "write_uid", name: "project_tags_write_uid_fkey", on_delete: :nullify
  add_foreign_key "project_tags_project_task_rel", "project_tags", column: "project_tags_id", name: "project_tags_project_task_rel_project_tags_id_fkey", on_delete: :cascade
  add_foreign_key "project_tags_project_task_rel", "project_task", name: "project_tags_project_task_rel_project_task_id_fkey", on_delete: :cascade
  add_foreign_key "project_task", "ir_attachment", column: "displayed_image_id", name: "project_task_displayed_image_id_fkey", on_delete: :nullify
  add_foreign_key "project_task", "project_project", column: "project_id", name: "project_task_project_id_fkey", on_delete: :nullify
  add_foreign_key "project_task", "project_task", column: "parent_id", name: "project_task_parent_id_fkey", on_delete: :nullify
  add_foreign_key "project_task", "project_task_type", column: "stage_id", name: "project_task_stage_id_fkey", on_delete: :nullify
  add_foreign_key "project_task", "res_company", column: "company_id", name: "project_task_company_id_fkey", on_delete: :nullify
  add_foreign_key "project_task", "res_partner", column: "partner_id", name: "project_task_partner_id_fkey", on_delete: :nullify
  add_foreign_key "project_task", "res_users", column: "create_uid", name: "project_task_create_uid_fkey", on_delete: :nullify
  add_foreign_key "project_task", "res_users", column: "user_id", name: "project_task_user_id_fkey", on_delete: :nullify
  add_foreign_key "project_task", "res_users", column: "write_uid", name: "project_task_write_uid_fkey", on_delete: :nullify
  add_foreign_key "project_task", "sale_order_line", column: "sale_line_id", name: "project_task_sale_line_id_fkey", on_delete: :nullify
  add_foreign_key "project_task_merge_wizard", "project_project", column: "target_project_id", name: "project_task_merge_wizard_target_project_id_fkey", on_delete: :nullify
  add_foreign_key "project_task_merge_wizard", "project_task", column: "target_task_id", name: "project_task_merge_wizard_target_task_id_fkey", on_delete: :nullify
  add_foreign_key "project_task_merge_wizard", "res_users", column: "create_uid", name: "project_task_merge_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "project_task_merge_wizard", "res_users", column: "user_id", name: "project_task_merge_wizard_user_id_fkey", on_delete: :nullify
  add_foreign_key "project_task_merge_wizard", "res_users", column: "write_uid", name: "project_task_merge_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "project_task_project_task_merge_wizard_rel", "project_task", name: "project_task_project_task_merge_wizard_rel_project_task_id_fkey", on_delete: :cascade
  add_foreign_key "project_task_project_task_merge_wizard_rel", "project_task_merge_wizard", name: "project_task_project_task_mer_project_task_merge_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "project_task_type", "mail_template", name: "project_task_type_mail_template_id_fkey", on_delete: :nullify
  add_foreign_key "project_task_type", "res_users", column: "create_uid", name: "project_task_type_create_uid_fkey", on_delete: :nullify
  add_foreign_key "project_task_type", "res_users", column: "write_uid", name: "project_task_type_write_uid_fkey", on_delete: :nullify
  add_foreign_key "project_task_type_rel", "project_project", column: "project_id", name: "project_task_type_rel_project_id_fkey", on_delete: :cascade
  add_foreign_key "project_task_type_rel", "project_task_type", column: "type_id", name: "project_task_type_rel_type_id_fkey", on_delete: :cascade
  add_foreign_key "question_choices", "questions"
  add_foreign_key "questions", "op_lession"
  add_foreign_key "rating_rating", "ir_model", column: "parent_res_model_id", name: "rating_rating_parent_res_model_id_fkey", on_delete: :nullify
  add_foreign_key "rating_rating", "ir_model", column: "res_model_id", name: "rating_rating_res_model_id_fkey", on_delete: :cascade
  add_foreign_key "rating_rating", "mail_message", column: "message_id", name: "rating_rating_message_id_fkey", on_delete: :nullify
  add_foreign_key "rating_rating", "res_partner", column: "partner_id", name: "rating_rating_partner_id_fkey", on_delete: :nullify
  add_foreign_key "rating_rating", "res_partner", column: "rated_partner_id", name: "rating_rating_rated_partner_id_fkey", on_delete: :nullify
  add_foreign_key "rating_rating", "res_users", column: "create_uid", name: "rating_rating_create_uid_fkey", on_delete: :nullify
  add_foreign_key "rating_rating", "res_users", column: "write_uid", name: "rating_rating_write_uid_fkey", on_delete: :nullify
  add_foreign_key "recruitment_source", "res_users", column: "create_uid", name: "recruitment_source_create_uid_fkey", on_delete: :nullify
  add_foreign_key "recruitment_source", "res_users", column: "write_uid", name: "recruitment_source_write_uid_fkey", on_delete: :nullify
  add_foreign_key "rel_badge_auth_users", "gamification_badge", name: "rel_badge_auth_users_gamification_badge_id_fkey", on_delete: :cascade
  add_foreign_key "rel_badge_auth_users", "res_users", column: "res_users_id", name: "rel_badge_auth_users_res_users_id_fkey", on_delete: :cascade
  add_foreign_key "rel_channel_groups", "res_groups", column: "group_id", name: "rel_channel_groups_group_id_fkey", on_delete: :cascade
  add_foreign_key "rel_channel_groups", "slide_channel", column: "channel_id", name: "rel_channel_groups_channel_id_fkey", on_delete: :cascade
  add_foreign_key "rel_modules_langexport", "base_language_export", column: "wiz_id", name: "rel_modules_langexport_wiz_id_fkey", on_delete: :cascade
  add_foreign_key "rel_modules_langexport", "ir_module_module", column: "module_id", name: "rel_modules_langexport_module_id_fkey", on_delete: :cascade
  add_foreign_key "rel_server_actions", "ir_act_server", column: "action_id", name: "rel_server_actions_action_id_fkey", on_delete: :cascade
  add_foreign_key "rel_server_actions", "ir_act_server", column: "server_id", name: "rel_server_actions_server_id_fkey", on_delete: :cascade
  add_foreign_key "rel_slide_tag", "slide_slide", column: "slide_id", name: "rel_slide_tag_slide_id_fkey", on_delete: :cascade
  add_foreign_key "rel_slide_tag", "slide_tag", column: "tag_id", name: "rel_slide_tag_tag_id_fkey", on_delete: :cascade
  add_foreign_key "rel_upload_groups", "res_groups", column: "group_id", name: "rel_upload_groups_group_id_fkey", on_delete: :cascade
  add_foreign_key "rel_upload_groups", "slide_channel", column: "channel_id", name: "rel_upload_groups_channel_id_fkey", on_delete: :cascade
  add_foreign_key "remove_draft_session", "op_batch", column: "batch_id", name: "remove_draft_session_batch_id_fkey", on_delete: :nullify
  add_foreign_key "remove_draft_session", "op_course", column: "course_id", name: "remove_draft_session_course_id_fkey", on_delete: :nullify
  add_foreign_key "remove_draft_session", "res_users", column: "create_uid", name: "remove_draft_session_create_uid_fkey", on_delete: :nullify
  add_foreign_key "remove_draft_session", "res_users", column: "write_uid", name: "remove_draft_session_write_uid_fkey", on_delete: :nullify
  add_foreign_key "report_paperformat", "res_users", column: "create_uid", name: "report_paperformat_create_uid_fkey", on_delete: :nullify
  add_foreign_key "report_paperformat", "res_users", column: "write_uid", name: "report_paperformat_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_bank", "res_country", column: "country", name: "res_bank_country_fkey", on_delete: :nullify
  add_foreign_key "res_bank", "res_country_state", column: "state", name: "res_bank_state_fkey", on_delete: :nullify
  add_foreign_key "res_bank", "res_users", column: "create_uid", name: "res_bank_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_bank", "res_users", column: "write_uid", name: "res_bank_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_company", "account_account", column: "property_stock_account_input_categ_id", name: "res_company_property_stock_account_input_categ_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "account_account", column: "property_stock_account_output_categ_id", name: "res_company_property_stock_account_output_categ_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "account_account", column: "property_stock_valuation_account_id", name: "res_company_property_stock_valuation_account_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "account_account", column: "transfer_account_id", name: "res_company_transfer_account_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "account_chart_template", column: "chart_template_id", name: "res_company_chart_template_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "account_journal", column: "currency_exchange_journal_id", name: "res_company_currency_exchange_journal_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "account_journal", column: "tax_cash_basis_journal_id", name: "res_company_tax_cash_basis_journal_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "account_move", column: "account_opening_move_id", name: "res_company_account_opening_move_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "product_uom", column: "project_time_mode_id", name: "res_company_project_time_mode_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "project_project", column: "leave_timesheet_project_id", name: "res_company_leave_timesheet_project_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "project_task", column: "leave_timesheet_task_id", name: "res_company_leave_timesheet_task_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "report_paperformat", column: "paperformat_id", name: "res_company_paperformat_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "res_company", column: "parent_id", name: "res_company_parent_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "res_currency", column: "currency_id", name: "res_company_currency_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "res_partner", column: "partner_id", name: "res_company_partner_id_fkey", on_delete: :nullify
  add_foreign_key "res_company", "res_users", column: "create_uid", name: "res_company_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_company", "res_users", column: "write_uid", name: "res_company_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_company", "resource_calendar", name: "res_company_resource_calendar_id_fkey", on_delete: :restrict
  add_foreign_key "res_company_users_rel", "res_company", column: "cid", name: "res_company_users_rel_cid_fkey", on_delete: :cascade
  add_foreign_key "res_company_users_rel", "res_users", column: "user_id", name: "res_company_users_rel_user_id_fkey", on_delete: :cascade
  add_foreign_key "res_config", "res_users", column: "create_uid", name: "res_config_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_config", "res_users", column: "write_uid", name: "res_config_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_config_installer", "res_users", column: "create_uid", name: "res_config_installer_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_config_installer", "res_users", column: "write_uid", name: "res_config_installer_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "account_chart_template", column: "chart_template_id", name: "res_config_settings_chart_template_id_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "product_product", column: "default_deposit_product_id", name: "res_config_settings_default_deposit_product_id_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "res_company", column: "company_id", name: "res_config_settings_company_id_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "res_users", column: "auth_signup_template_user_id", name: "res_config_settings_auth_signup_template_user_id_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "res_users", column: "create_uid", name: "res_config_settings_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "res_users", column: "write_uid", name: "res_config_settings_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "survey_survey", column: "default_survey_id", name: "res_config_settings_default_survey_id_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "survey_survey", column: "student_test_survey_id", name: "res_config_settings_student_test_survey_id_fkey", on_delete: :nullify
  add_foreign_key "res_config_settings", "website", name: "res_config_settings_website_id_fkey", on_delete: :nullify
  add_foreign_key "res_country", "ir_ui_view", column: "address_view_id", name: "res_country_address_view_id_fkey", on_delete: :nullify
  add_foreign_key "res_country", "res_currency", column: "currency_id", name: "res_country_currency_id_fkey", on_delete: :nullify
  add_foreign_key "res_country", "res_users", column: "create_uid", name: "res_country_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_country", "res_users", column: "write_uid", name: "res_country_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_country_group", "res_users", column: "create_uid", name: "res_country_group_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_country_group", "res_users", column: "write_uid", name: "res_country_group_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_country_group_pricelist_rel", "product_pricelist", column: "pricelist_id", name: "res_country_group_pricelist_rel_pricelist_id_fkey", on_delete: :cascade
  add_foreign_key "res_country_group_pricelist_rel", "res_country_group", name: "res_country_group_pricelist_rel_res_country_group_id_fkey", on_delete: :cascade
  add_foreign_key "res_country_res_country_group_rel", "res_country", name: "res_country_res_country_group_rel_res_country_id_fkey", on_delete: :cascade
  add_foreign_key "res_country_res_country_group_rel", "res_country_group", name: "res_country_res_country_group_rel_res_country_group_id_fkey", on_delete: :cascade
  add_foreign_key "res_country_state", "res_country", column: "country_id", name: "res_country_state_country_id_fkey", on_delete: :nullify
  add_foreign_key "res_country_state", "res_users", column: "create_uid", name: "res_country_state_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_country_state", "res_users", column: "write_uid", name: "res_country_state_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_currency", "res_users", column: "create_uid", name: "res_currency_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_currency", "res_users", column: "write_uid", name: "res_currency_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_currency_rate", "res_company", column: "company_id", name: "res_currency_rate_company_id_fkey", on_delete: :nullify
  add_foreign_key "res_currency_rate", "res_currency", column: "currency_id", name: "res_currency_rate_currency_id_fkey", on_delete: :nullify
  add_foreign_key "res_currency_rate", "res_users", column: "create_uid", name: "res_currency_rate_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_currency_rate", "res_users", column: "write_uid", name: "res_currency_rate_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_district", "res_province", column: "province_id", name: "res_district_province_id_fkey", on_delete: :nullify
  add_foreign_key "res_district", "res_users", column: "create_uid", name: "res_district_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_district", "res_users", column: "write_uid", name: "res_district_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_groups", "ir_module_category", column: "category_id", name: "res_groups_category_id_fkey", on_delete: :nullify
  add_foreign_key "res_groups", "res_users", column: "create_uid", name: "res_groups_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_groups", "res_users", column: "write_uid", name: "res_groups_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_groups_implied_rel", "res_groups", column: "gid", name: "res_groups_implied_rel_gid_fkey", on_delete: :cascade
  add_foreign_key "res_groups_implied_rel", "res_groups", column: "hid", name: "res_groups_implied_rel_hid_fkey", on_delete: :cascade
  add_foreign_key "res_groups_report_rel", "ir_act_report_xml", column: "uid", name: "res_groups_report_rel_uid_fkey", on_delete: :cascade
  add_foreign_key "res_groups_report_rel", "res_groups", column: "gid", name: "res_groups_report_rel_gid_fkey", on_delete: :cascade
  add_foreign_key "res_groups_users_rel", "res_groups", column: "gid", name: "res_groups_users_rel_gid_fkey", on_delete: :cascade
  add_foreign_key "res_groups_users_rel", "res_users", column: "uid", name: "res_groups_users_rel_uid_fkey", on_delete: :cascade
  add_foreign_key "res_lang", "res_users", column: "create_uid", name: "res_lang_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_lang", "res_users", column: "write_uid", name: "res_lang_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "crm_team", column: "team_id", name: "res_partner_team_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_company", column: "company_id", name: "res_partner_company_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_country", column: "commercial_partner_country_id", name: "res_partner_commercial_partner_country_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_country", column: "country_id", name: "res_partner_country_id_fkey", on_delete: :restrict
  add_foreign_key "res_partner", "res_country_state", column: "state_id", name: "res_partner_state_id_fkey", on_delete: :restrict
  add_foreign_key "res_partner", "res_district", column: "district_id", name: "res_partner_district_id_fkey", on_delete: :restrict
  add_foreign_key "res_partner", "res_partner", column: "commercial_partner_id", name: "res_partner_commercial_partner_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_partner", column: "parent_id", name: "res_partner_parent_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_partner_industry", column: "industry_id", name: "res_partner_industry_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_partner_title", column: "title", name: "res_partner_title_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_province", column: "province_id", name: "res_partner_province_id_fkey", on_delete: :restrict
  add_foreign_key "res_partner", "res_users", column: "create_uid", name: "res_partner_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_users", column: "user_id", name: "res_partner_user_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_users", column: "write_uid", name: "res_partner_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner", "res_ward", column: "ward_id", name: "res_partner_ward_id_fkey", on_delete: :restrict
  add_foreign_key "res_partner_bank", "res_bank", column: "bank_id", name: "res_partner_bank_bank_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner_bank", "res_company", column: "company_id", name: "res_partner_bank_company_id_fkey", on_delete: :cascade
  add_foreign_key "res_partner_bank", "res_currency", column: "currency_id", name: "res_partner_bank_currency_id_fkey", on_delete: :nullify
  add_foreign_key "res_partner_bank", "res_partner", column: "partner_id", name: "res_partner_bank_partner_id_fkey", on_delete: :cascade
  add_foreign_key "res_partner_bank", "res_users", column: "create_uid", name: "res_partner_bank_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner_bank", "res_users", column: "write_uid", name: "res_partner_bank_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner_category", "res_partner_category", column: "parent_id", name: "res_partner_category_parent_id_fkey", on_delete: :cascade
  add_foreign_key "res_partner_category", "res_users", column: "create_uid", name: "res_partner_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner_category", "res_users", column: "write_uid", name: "res_partner_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner_industry", "res_users", column: "create_uid", name: "res_partner_industry_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner_industry", "res_users", column: "write_uid", name: "res_partner_industry_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner_res_partner_category_rel", "res_partner", column: "partner_id", name: "res_partner_res_partner_category_rel_partner_id_fkey", on_delete: :cascade
  add_foreign_key "res_partner_res_partner_category_rel", "res_partner_category", column: "category_id", name: "res_partner_res_partner_category_rel_category_id_fkey", on_delete: :cascade
  add_foreign_key "res_partner_title", "res_users", column: "create_uid", name: "res_partner_title_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_partner_title", "res_users", column: "write_uid", name: "res_partner_title_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_province", "res_country", column: "country_id", name: "res_province_country_id_fkey", on_delete: :nullify
  add_foreign_key "res_province", "res_users", column: "create_uid", name: "res_province_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_province", "res_users", column: "write_uid", name: "res_province_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_request_link", "res_users", column: "create_uid", name: "res_request_link_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_request_link", "res_users", column: "write_uid", name: "res_request_link_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_user_first_rel1", "res_users", column: "res_user_second_rel1", name: "res_user_first_rel1_res_user_second_rel1_fkey", on_delete: :cascade
  add_foreign_key "res_user_first_rel1", "res_users", column: "user_id", name: "res_user_first_rel1_user_id_fkey", on_delete: :cascade
  add_foreign_key "res_users", "auth_oauth_provider", column: "oauth_provider_id", name: "res_users_oauth_provider_id_fkey", on_delete: :nullify
  add_foreign_key "res_users", "crm_team", column: "sale_team_id", name: "res_users_sale_team_id_fkey", on_delete: :nullify
  add_foreign_key "res_users", "mail_alias", column: "alias_id", name: "res_users_alias_id_fkey", on_delete: :nullify
  add_foreign_key "res_users", "res_company", column: "company_id", name: "res_users_company_id_fkey", on_delete: :nullify
  add_foreign_key "res_users", "res_partner", column: "partner_id", name: "res_users_partner_id_fkey", on_delete: :restrict
  add_foreign_key "res_users", "res_users", column: "create_uid", name: "res_users_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_users", "res_users", column: "write_uid", name: "res_users_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_users_log", "res_users", column: "create_uid", name: "res_users_log_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_users_log", "res_users", column: "write_uid", name: "res_users_log_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_users_role", "res_groups", column: "group_id", name: "res_users_role_group_id_fkey", on_delete: :cascade
  add_foreign_key "res_users_role", "res_users", column: "create_uid", name: "res_users_role_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_users_role", "res_users", column: "write_uid", name: "res_users_role_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_users_role_line", "res_users", column: "create_uid", name: "res_users_role_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_users_role_line", "res_users", column: "user_id", name: "res_users_role_line_user_id_fkey", on_delete: :nullify
  add_foreign_key "res_users_role_line", "res_users", column: "write_uid", name: "res_users_role_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "res_users_role_line", "res_users_role", column: "role_id", name: "res_users_role_line_role_id_fkey", on_delete: :cascade
  add_foreign_key "res_ward", "res_district", column: "district_id", name: "res_ward_district_id_fkey", on_delete: :nullify
  add_foreign_key "res_ward", "res_users", column: "create_uid", name: "res_ward_create_uid_fkey", on_delete: :nullify
  add_foreign_key "res_ward", "res_users", column: "write_uid", name: "res_ward_write_uid_fkey", on_delete: :nullify
  add_foreign_key "reserve_media", "res_partner", column: "partner_id", name: "reserve_media_partner_id_fkey", on_delete: :nullify
  add_foreign_key "reserve_media", "res_users", column: "create_uid", name: "reserve_media_create_uid_fkey", on_delete: :nullify
  add_foreign_key "reserve_media", "res_users", column: "write_uid", name: "reserve_media_write_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar", "res_company", column: "company_id", name: "resource_calendar_company_id_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar", "res_users", column: "create_uid", name: "resource_calendar_create_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar", "res_users", column: "write_uid", name: "resource_calendar_write_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar_attendance", "res_users", column: "create_uid", name: "resource_calendar_attendance_create_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar_attendance", "res_users", column: "write_uid", name: "resource_calendar_attendance_write_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar_attendance", "resource_calendar", column: "calendar_id", name: "resource_calendar_attendance_calendar_id_fkey", on_delete: :cascade
  add_foreign_key "resource_calendar_leaves", "hr_holidays", column: "holiday_id", name: "resource_calendar_leaves_holiday_id_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar_leaves", "res_company", column: "company_id", name: "resource_calendar_leaves_company_id_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar_leaves", "res_users", column: "create_uid", name: "resource_calendar_leaves_create_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar_leaves", "res_users", column: "write_uid", name: "resource_calendar_leaves_write_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar_leaves", "resource_calendar", column: "calendar_id", name: "resource_calendar_leaves_calendar_id_fkey", on_delete: :nullify
  add_foreign_key "resource_calendar_leaves", "resource_resource", column: "resource_id", name: "resource_calendar_leaves_resource_id_fkey", on_delete: :nullify
  add_foreign_key "resource_resource", "res_company", column: "company_id", name: "resource_resource_company_id_fkey", on_delete: :nullify
  add_foreign_key "resource_resource", "res_users", column: "create_uid", name: "resource_resource_create_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_resource", "res_users", column: "user_id", name: "resource_resource_user_id_fkey", on_delete: :nullify
  add_foreign_key "resource_resource", "res_users", column: "write_uid", name: "resource_resource_write_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_resource", "resource_calendar", column: "calendar_id", name: "resource_resource_calendar_id_fkey", on_delete: :nullify
  add_foreign_key "resource_test", "res_company", column: "company_id", name: "resource_test_company_id_fkey", on_delete: :nullify
  add_foreign_key "resource_test", "res_users", column: "create_uid", name: "resource_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_test", "res_users", column: "write_uid", name: "resource_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "resource_test", "resource_resource", column: "resource_id", name: "resource_test_resource_id_fkey", on_delete: :restrict
  add_foreign_key "return_media", "op_media", column: "media_id", name: "return_media_media_id_fkey", on_delete: :nullify
  add_foreign_key "return_media", "op_media_unit", column: "media_unit_id", name: "return_media_media_unit_id_fkey", on_delete: :nullify
  add_foreign_key "return_media", "res_users", column: "create_uid", name: "return_media_create_uid_fkey", on_delete: :nullify
  add_foreign_key "return_media", "res_users", column: "write_uid", name: "return_media_write_uid_fkey", on_delete: :nullify
  add_foreign_key "rule_group_rel", "ir_rule", column: "rule_group_id", name: "rule_group_rel_rule_group_id_fkey", on_delete: :cascade
  add_foreign_key "rule_group_rel", "res_groups", column: "group_id", name: "rule_group_rel_group_id_fkey", on_delete: :cascade
  add_foreign_key "sale_advance_payment_inv", "account_account", column: "deposit_account_id", name: "sale_advance_payment_inv_deposit_account_id_fkey", on_delete: :nullify
  add_foreign_key "sale_advance_payment_inv", "product_product", column: "product_id", name: "sale_advance_payment_inv_product_id_fkey", on_delete: :nullify
  add_foreign_key "sale_advance_payment_inv", "res_users", column: "create_uid", name: "sale_advance_payment_inv_create_uid_fkey", on_delete: :nullify
  add_foreign_key "sale_advance_payment_inv", "res_users", column: "write_uid", name: "sale_advance_payment_inv_write_uid_fkey", on_delete: :nullify
  add_foreign_key "sale_layout_category", "res_users", column: "create_uid", name: "sale_layout_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "sale_layout_category", "res_users", column: "write_uid", name: "sale_layout_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "account_analytic_account", column: "analytic_account_id", name: "sale_order_analytic_account_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "account_fiscal_position", column: "fiscal_position_id", name: "sale_order_fiscal_position_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "account_journal", column: "journal_id", name: "sale_order_journal_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "account_payment_term", column: "payment_term_id", name: "sale_order_payment_term_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "crm_lead", column: "opportunity_id", name: "sale_order_opportunity_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "crm_team", column: "team_id", name: "sale_order_team_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "payment_acquirer", name: "sale_order_payment_acquirer_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "payment_transaction", column: "payment_tx_id", name: "sale_order_payment_tx_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "product_pricelist", column: "pricelist_id", name: "sale_order_pricelist_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "res_company", column: "admission_company_id", name: "sale_order_admission_company_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "res_company", column: "company_id", name: "sale_order_company_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "res_partner", column: "partner_id", name: "sale_order_partner_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "res_partner", column: "partner_invoice_id", name: "sale_order_partner_invoice_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "res_partner", column: "partner_shipping_id", name: "sale_order_partner_shipping_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "res_users", column: "create_uid", name: "sale_order_create_uid_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "res_users", column: "user_id", name: "sale_order_user_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "res_users", column: "write_uid", name: "sale_order_write_uid_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "sale_order", column: "main_order", name: "sale_order_main_order_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "utm_campaign", column: "campaign_id", name: "sale_order_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "utm_medium", column: "medium_id", name: "sale_order_medium_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order", "utm_source", column: "source_id", name: "sale_order_source_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "op_batch", column: "batch_id", name: "sale_order_line_batch_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "op_course", column: "course_id", name: "sale_order_line_course_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "op_faculty", column: "faculty_id", name: "sale_order_line_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "op_student", column: "student_id", name: "sale_order_line_student_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "product_product", column: "product_id", name: "sale_order_line_product_id_fkey", on_delete: :restrict
  add_foreign_key "sale_order_line", "product_uom", column: "product_uom", name: "sale_order_line_product_uom_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "project_task", column: "task_id", name: "sale_order_line_task_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "res_company", column: "company_id", name: "sale_order_line_company_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "res_currency", column: "currency_id", name: "sale_order_line_currency_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "res_partner", column: "order_partner_id", name: "sale_order_line_order_partner_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "res_users", column: "create_uid", name: "sale_order_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "res_users", column: "salesman_id", name: "sale_order_line_salesman_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "res_users", column: "write_uid", name: "sale_order_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "sale_layout_category", column: "layout_category_id", name: "sale_order_line_layout_category_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line", "sale_order", column: "order_id", name: "sale_order_line_order_id_fkey", on_delete: :cascade
  add_foreign_key "sale_order_line", "student_test", name: "sale_order_line_student_test_id_fkey", on_delete: :nullify
  add_foreign_key "sale_order_line_invoice_rel", "account_invoice_line", column: "invoice_line_id", name: "sale_order_line_invoice_rel_invoice_line_id_fkey", on_delete: :cascade
  add_foreign_key "sale_order_line_invoice_rel", "sale_order_line", column: "order_line_id", name: "sale_order_line_invoice_rel_order_line_id_fkey", on_delete: :cascade
  add_foreign_key "sale_order_line_subject_rel", "op_subject", column: "subject_id", name: "sale_order_line_subject_rel_subject_id_fkey", on_delete: :cascade
  add_foreign_key "sale_order_line_subject_rel", "sale_order_line", column: "order_line_id", name: "sale_order_line_subject_rel_order_line_id_fkey", on_delete: :cascade
  add_foreign_key "sale_order_tag_rel", "crm_lead_tag", column: "tag_id", name: "sale_order_tag_rel_tag_id_fkey", on_delete: :cascade
  add_foreign_key "sale_order_tag_rel", "sale_order", column: "order_id", name: "sale_order_tag_rel_order_id_fkey", on_delete: :cascade
  add_foreign_key "session_change_tutors_id", "op_faculty", column: "faculty_id", name: "session_change_tutors_id_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "session_change_tutors_id", "op_session_change_faculty", column: "change_id", name: "session_change_tutors_id_change_id_fkey", on_delete: :cascade
  add_foreign_key "session_confirmation", "res_users", column: "create_uid", name: "session_confirmation_create_uid_fkey", on_delete: :nullify
  add_foreign_key "session_confirmation", "res_users", column: "write_uid", name: "session_confirmation_write_uid_fkey", on_delete: :nullify
  add_foreign_key "session_fa_rel", "op_faculty", column: "partner_id", name: "session_fa_rel_partner_id_fkey", on_delete: :cascade
  add_foreign_key "session_fa_rel", "op_session", column: "name", name: "session_fa_rel_name_fkey", on_delete: :cascade
  add_foreign_key "slide_category", "res_users", column: "create_uid", name: "slide_category_create_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_category", "res_users", column: "write_uid", name: "slide_category_write_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_category", "slide_channel", column: "channel_id", name: "slide_category_channel_id_fkey", on_delete: :cascade
  add_foreign_key "slide_channel", "mail_template", column: "publish_template_id", name: "slide_channel_publish_template_id_fkey", on_delete: :nullify
  add_foreign_key "slide_channel", "mail_template", column: "share_template_id", name: "slide_channel_share_template_id_fkey", on_delete: :nullify
  add_foreign_key "slide_channel", "res_users", column: "create_uid", name: "slide_channel_create_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_channel", "res_users", column: "write_uid", name: "slide_channel_write_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_channel", "slide_slide", column: "custom_slide_id", name: "slide_channel_custom_slide_id_fkey", on_delete: :nullify
  add_foreign_key "slide_channel", "slide_slide", column: "promoted_slide_id", name: "slide_channel_promoted_slide_id_fkey", on_delete: :nullify
  add_foreign_key "slide_embed", "res_users", column: "create_uid", name: "slide_embed_create_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_embed", "res_users", column: "write_uid", name: "slide_embed_write_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_embed", "slide_slide", column: "slide_id", name: "slide_embed_slide_id_fkey", on_delete: :nullify
  add_foreign_key "slide_slide", "res_users", column: "create_uid", name: "slide_slide_create_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_slide", "res_users", column: "write_uid", name: "slide_slide_write_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_slide", "slide_category", column: "category_id", name: "slide_slide_category_id_fkey", on_delete: :nullify
  add_foreign_key "slide_slide", "slide_channel", column: "channel_id", name: "slide_slide_channel_id_fkey", on_delete: :nullify
  add_foreign_key "slide_tag", "res_users", column: "create_uid", name: "slide_tag_create_uid_fkey", on_delete: :nullify
  add_foreign_key "slide_tag", "res_users", column: "write_uid", name: "slide_tag_write_uid_fkey", on_delete: :nullify
  add_foreign_key "sms_send_sms", "res_users", column: "create_uid", name: "sms_send_sms_create_uid_fkey", on_delete: :nullify
  add_foreign_key "sms_send_sms", "res_users", column: "write_uid", name: "sms_send_sms_write_uid_fkey", on_delete: :nullify
  add_foreign_key "sparse_fields_test", "res_users", column: "create_uid", name: "sparse_fields_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "sparse_fields_test", "res_users", column: "write_uid", name: "sparse_fields_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "student_attendance", "res_users", column: "create_uid", name: "student_attendance_create_uid_fkey", on_delete: :nullify
  add_foreign_key "student_attendance", "res_users", column: "write_uid", name: "student_attendance_write_uid_fkey", on_delete: :nullify
  add_foreign_key "student_hall_ticket", "op_exam_session", column: "exam_session_id", name: "student_hall_ticket_exam_session_id_fkey", on_delete: :nullify
  add_foreign_key "student_hall_ticket", "res_users", column: "create_uid", name: "student_hall_ticket_create_uid_fkey", on_delete: :nullify
  add_foreign_key "student_hall_ticket", "res_users", column: "write_uid", name: "student_hall_ticket_write_uid_fkey", on_delete: :nullify
  add_foreign_key "student_leave", "op_batch", column: "batch_id", name: "student_leave_batch_id_fkey", on_delete: :nullify
  add_foreign_key "student_leave", "op_course", column: "course_id", name: "student_leave_course_id_fkey", on_delete: :nullify
  add_foreign_key "student_leave", "res_users", column: "create_uid", name: "student_leave_create_uid_fkey", on_delete: :nullify
  add_foreign_key "student_leave", "res_users", column: "user_id", name: "student_leave_user_id_fkey", on_delete: :nullify
  add_foreign_key "student_leave", "res_users", column: "write_uid", name: "student_leave_write_uid_fkey", on_delete: :nullify
  add_foreign_key "student_leave_student", "op_student", column: "student_id", name: "student_leave_student_student_id_fkey", on_delete: :cascade
  add_foreign_key "student_leave_student", "student_leave", name: "student_leave_student_student_leave_id_fkey", on_delete: :cascade
  add_foreign_key "student_migrate", "op_batch", column: "batch_from_id", name: "student_migrate_batch_from_id_fkey", on_delete: :nullify
  add_foreign_key "student_migrate", "op_batch", column: "batch_id", name: "student_migrate_batch_id_fkey", on_delete: :nullify
  add_foreign_key "student_migrate", "op_course", column: "course_from_id", name: "student_migrate_course_from_id_fkey", on_delete: :nullify
  add_foreign_key "student_migrate", "op_course", column: "course_to_id", name: "student_migrate_course_to_id_fkey", on_delete: :nullify
  add_foreign_key "student_migrate", "res_users", column: "create_uid", name: "student_migrate_create_uid_fkey", on_delete: :nullify
  add_foreign_key "student_migrate", "res_users", column: "write_uid", name: "student_migrate_write_uid_fkey", on_delete: :nullify
  add_foreign_key "student_test", "crm_lead", column: "opportunity_id", name: "student_test_opportunity_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "crm_team", column: "sale_channel_id", name: "student_test_sale_channel_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "op_batch", column: "batch_id", name: "student_test_batch_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "op_course", column: "confirm_course_id", name: "student_test_confirm_course_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "op_course", column: "course_id", name: "student_test_course_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "op_faculty", column: "faculty_id", name: "student_test_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "op_student", column: "student_id", name: "student_test_student_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "product_product", column: "product_id", name: "student_test_product_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "res_company", column: "company_id", name: "student_test_company_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "res_currency", column: "currency_id", name: "student_test_currency_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "res_partner", column: "partner_id", name: "student_test_partner_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "res_users", column: "create_uid", name: "student_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "student_test", "res_users", column: "user_id", name: "student_test_user_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "res_users", column: "write_uid", name: "student_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "student_test", "sale_order", column: "order_id", name: "student_test_order_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "sale_order_line", column: "order_line_id", name: "student_test_order_line_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "survey_survey", column: "survey_id", name: "student_test_survey_id_fkey", on_delete: :nullify
  add_foreign_key "student_test", "survey_user_input", column: "input_id", name: "student_test_input_id_fkey", on_delete: :nullify
  add_foreign_key "student_test_wizard", "res_users", column: "create_uid", name: "student_test_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "student_test_wizard", "res_users", column: "write_uid", name: "student_test_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "subject_compulsory_rel", "op_subject", column: "subject_id", name: "subject_compulsory_rel_subject_id_fkey", on_delete: :cascade
  add_foreign_key "subject_compulsory_rel", "op_subject_registration", column: "register_id", name: "subject_compulsory_rel_register_id_fkey", on_delete: :cascade
  add_foreign_key "summary_dept_rel", "hr_department", column: "dept_id", name: "summary_dept_rel_dept_id_fkey", on_delete: :cascade
  add_foreign_key "summary_dept_rel", "hr_holidays_summary_dept", column: "sum_id", name: "summary_dept_rel_sum_id_fkey", on_delete: :cascade
  add_foreign_key "summary_emp_rel", "hr_employee", column: "emp_id", name: "summary_emp_rel_emp_id_fkey", on_delete: :cascade
  add_foreign_key "summary_emp_rel", "hr_holidays_summary_employee", column: "sum_id", name: "summary_emp_rel_sum_id_fkey", on_delete: :cascade
  add_foreign_key "survey_label", "res_users", column: "create_uid", name: "survey_label_create_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_label", "res_users", column: "write_uid", name: "survey_label_write_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_label", "survey_question", column: "question_id", name: "survey_label_question_id_fkey", on_delete: :cascade
  add_foreign_key "survey_label", "survey_question", column: "question_id_2", name: "survey_label_question_id_2_fkey", on_delete: :cascade
  add_foreign_key "survey_mail_compose_message", "ir_mail_server", column: "mail_server_id", name: "survey_mail_compose_message_mail_server_id_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "mail_activity_type", name: "survey_mail_compose_message_mail_activity_type_id_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "mail_mass_mailing", column: "mass_mailing_id", name: "survey_mail_compose_message_mass_mailing_id_fkey", on_delete: :cascade
  add_foreign_key "survey_mail_compose_message", "mail_mass_mailing_campaign", column: "mass_mailing_campaign_id", name: "survey_mail_compose_message_mass_mailing_campaign_id_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "mail_message", column: "parent_id", name: "survey_mail_compose_message_parent_id_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "mail_message_subtype", column: "subtype_id", name: "survey_mail_compose_message_subtype_id_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "mail_template", column: "template_id", name: "survey_mail_compose_message_template_id_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "res_partner", column: "author_id", name: "survey_mail_compose_message_author_id_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "res_users", column: "create_uid", name: "survey_mail_compose_message_create_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "res_users", column: "write_uid", name: "survey_mail_compose_message_write_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message", "survey_survey", column: "survey_id", name: "survey_mail_compose_message_survey_id_fkey", on_delete: :nullify
  add_foreign_key "survey_mail_compose_message_ir_attachments_rel", "ir_attachment", column: "attachment_id", name: "survey_mail_compose_message_ir_attachments_r_attachment_id_fkey", on_delete: :cascade
  add_foreign_key "survey_mail_compose_message_ir_attachments_rel", "survey_mail_compose_message", column: "wizard_id", name: "survey_mail_compose_message_ir_attachments_rel_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "survey_mail_compose_message_res_partner_rel", "res_partner", column: "partner_id", name: "survey_mail_compose_message_res_partner_rel_partner_id_fkey", on_delete: :cascade
  add_foreign_key "survey_mail_compose_message_res_partner_rel", "survey_mail_compose_message", column: "wizard_id", name: "survey_mail_compose_message_res_partner_rel_wizard_id_fkey", on_delete: :cascade
  add_foreign_key "survey_page", "res_users", column: "create_uid", name: "survey_page_create_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_page", "res_users", column: "write_uid", name: "survey_page_write_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_page", "survey_survey", column: "survey_id", name: "survey_page_survey_id_fkey", on_delete: :cascade
  add_foreign_key "survey_question", "res_users", column: "create_uid", name: "survey_question_create_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_question", "res_users", column: "write_uid", name: "survey_question_write_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_question", "survey_page", column: "page_id", name: "survey_question_page_id_fkey", on_delete: :cascade
  add_foreign_key "survey_stage", "res_users", column: "create_uid", name: "survey_stage_create_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_stage", "res_users", column: "write_uid", name: "survey_stage_write_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_survey", "mail_template", column: "email_template_id", name: "survey_survey_email_template_id_fkey", on_delete: :nullify
  add_foreign_key "survey_survey", "res_users", column: "create_uid", name: "survey_survey_create_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_survey", "res_users", column: "write_uid", name: "survey_survey_write_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_survey", "survey_stage", column: "stage_id", name: "survey_survey_stage_id_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input", "res_partner", column: "partner_id", name: "survey_user_input_partner_id_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input", "res_users", column: "create_uid", name: "survey_user_input_create_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input", "res_users", column: "write_uid", name: "survey_user_input_write_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input", "survey_page", column: "last_displayed_page_id", name: "survey_user_input_last_displayed_page_id_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input", "survey_survey", column: "survey_id", name: "survey_user_input_survey_id_fkey", on_delete: :restrict
  add_foreign_key "survey_user_input_line", "res_users", column: "create_uid", name: "survey_user_input_line_create_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input_line", "res_users", column: "write_uid", name: "survey_user_input_line_write_uid_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input_line", "survey_label", column: "value_suggested", name: "survey_user_input_line_value_suggested_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input_line", "survey_label", column: "value_suggested_row", name: "survey_user_input_line_value_suggested_row_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input_line", "survey_question", column: "question_id", name: "survey_user_input_line_question_id_fkey", on_delete: :restrict
  add_foreign_key "survey_user_input_line", "survey_survey", column: "survey_id", name: "survey_user_input_line_survey_id_fkey", on_delete: :nullify
  add_foreign_key "survey_user_input_line", "survey_user_input", column: "user_input_id", name: "survey_user_input_line_user_input_id_fkey", on_delete: :cascade
  add_foreign_key "tax_adjustments_wizard", "account_account", column: "credit_account_id", name: "tax_adjustments_wizard_credit_account_id_fkey", on_delete: :nullify
  add_foreign_key "tax_adjustments_wizard", "account_account", column: "debit_account_id", name: "tax_adjustments_wizard_debit_account_id_fkey", on_delete: :nullify
  add_foreign_key "tax_adjustments_wizard", "account_journal", column: "journal_id", name: "tax_adjustments_wizard_journal_id_fkey", on_delete: :nullify
  add_foreign_key "tax_adjustments_wizard", "account_tax", column: "tax_id", name: "tax_adjustments_wizard_tax_id_fkey", on_delete: :restrict
  add_foreign_key "tax_adjustments_wizard", "res_currency", column: "company_currency_id", name: "tax_adjustments_wizard_company_currency_id_fkey", on_delete: :nullify
  add_foreign_key "tax_adjustments_wizard", "res_users", column: "create_uid", name: "tax_adjustments_wizard_create_uid_fkey", on_delete: :nullify
  add_foreign_key "tax_adjustments_wizard", "res_users", column: "write_uid", name: "tax_adjustments_wizard_write_uid_fkey", on_delete: :nullify
  add_foreign_key "team_favorite_user_rel", "crm_team", column: "team_id", name: "team_favorite_user_rel_team_id_fkey", on_delete: :cascade
  add_foreign_key "team_favorite_user_rel", "res_users", column: "user_id", name: "team_favorite_user_rel_user_id_fkey", on_delete: :cascade
  add_foreign_key "teky_qldc", "hr_department", column: "department_id", name: "teky_qldc_department_id_fkey", on_delete: :nullify
  add_foreign_key "teky_qldc", "hr_employee", column: "employee_id", name: "teky_qldc_employee_id_fkey", on_delete: :nullify
  add_foreign_key "teky_qldc", "hr_employee", column: "parent_id", name: "teky_qldc_parent_id_fkey", on_delete: :nullify
  add_foreign_key "teky_qldc", "res_company", column: "company_id", name: "teky_qldc_company_id_fkey", on_delete: :nullify
  add_foreign_key "teky_qldc", "res_users", column: "create_uid", name: "teky_qldc_create_uid_fkey", on_delete: :nullify
  add_foreign_key "teky_qldc", "res_users", column: "user_id", name: "teky_qldc_user_id_fkey", on_delete: :nullify
  add_foreign_key "teky_qldc", "res_users", column: "write_uid", name: "teky_qldc_write_uid_fkey", on_delete: :nullify
  add_foreign_key "test_ir_rel", "ir_attachment", column: "attachment_id", name: "test_ir_rel_attachment_id_fkey", on_delete: :cascade
  add_foreign_key "test_ir_rel", "student_test", column: "test_id", name: "test_ir_rel_test_id_fkey", on_delete: :cascade
  add_foreign_key "time_table_report", "op_batch", column: "batch_id", name: "time_table_report_batch_id_fkey", on_delete: :nullify
  add_foreign_key "time_table_report", "op_course", column: "course_id", name: "time_table_report_course_id_fkey", on_delete: :nullify
  add_foreign_key "time_table_report", "op_faculty", column: "faculty_id", name: "time_table_report_faculty_id_fkey", on_delete: :nullify
  add_foreign_key "time_table_report", "res_users", column: "create_uid", name: "time_table_report_create_uid_fkey", on_delete: :nullify
  add_foreign_key "time_table_report", "res_users", column: "write_uid", name: "time_table_report_write_uid_fkey", on_delete: :nullify
  add_foreign_key "timetable_line_faculty_rel", "gen_time_table_line", column: "timetable_line_id", name: "timetable_line_faculty_rel_timetable_line_id_fkey", on_delete: :cascade
  add_foreign_key "timetable_line_faculty_rel", "op_faculty", column: "faculty_id", name: "timetable_line_faculty_rel_faculty_id_fkey", on_delete: :cascade
  add_foreign_key "user_answers", "op_faculty", column: "faculty_id"
  add_foreign_key "user_answers", "question_choices"
  add_foreign_key "user_answers", "user_questions"
  add_foreign_key "user_questions", "op_batch"
  add_foreign_key "user_questions", "questions"
  add_foreign_key "user_questions", "users", column: "student_id"
  add_foreign_key "utm_campaign", "res_users", column: "create_uid", name: "utm_campaign_create_uid_fkey", on_delete: :nullify
  add_foreign_key "utm_campaign", "res_users", column: "write_uid", name: "utm_campaign_write_uid_fkey", on_delete: :nullify
  add_foreign_key "utm_medium", "res_users", column: "create_uid", name: "utm_medium_create_uid_fkey", on_delete: :nullify
  add_foreign_key "utm_medium", "res_users", column: "write_uid", name: "utm_medium_write_uid_fkey", on_delete: :nullify
  add_foreign_key "utm_source", "res_users", column: "create_uid", name: "utm_source_create_uid_fkey", on_delete: :nullify
  add_foreign_key "utm_source", "res_users", column: "write_uid", name: "utm_source_write_uid_fkey", on_delete: :nullify
  add_foreign_key "validate_account_move", "res_users", column: "create_uid", name: "validate_account_move_create_uid_fkey", on_delete: :nullify
  add_foreign_key "validate_account_move", "res_users", column: "write_uid", name: "validate_account_move_write_uid_fkey", on_delete: :nullify
  add_foreign_key "web_editor_converter_test", "res_users", column: "create_uid", name: "web_editor_converter_test_create_uid_fkey", on_delete: :nullify
  add_foreign_key "web_editor_converter_test", "res_users", column: "write_uid", name: "web_editor_converter_test_write_uid_fkey", on_delete: :nullify
  add_foreign_key "web_editor_converter_test", "web_editor_converter_test_sub", column: "many2one", name: "web_editor_converter_test_many2one_fkey", on_delete: :nullify
  add_foreign_key "web_editor_converter_test_sub", "res_users", column: "create_uid", name: "web_editor_converter_test_sub_create_uid_fkey", on_delete: :nullify
  add_foreign_key "web_editor_converter_test_sub", "res_users", column: "write_uid", name: "web_editor_converter_test_sub_write_uid_fkey", on_delete: :nullify
  add_foreign_key "web_planner", "ir_ui_menu", column: "menu_id", name: "web_planner_menu_id_fkey", on_delete: :nullify
  add_foreign_key "web_planner", "ir_ui_view", column: "view_id", name: "web_planner_view_id_fkey", on_delete: :nullify
  add_foreign_key "web_planner", "res_users", column: "create_uid", name: "web_planner_create_uid_fkey", on_delete: :nullify
  add_foreign_key "web_planner", "res_users", column: "write_uid", name: "web_planner_write_uid_fkey", on_delete: :nullify
  add_foreign_key "web_tour_tour", "res_users", column: "user_id", name: "web_tour_tour_user_id_fkey", on_delete: :nullify
  add_foreign_key "website", "crm_team", column: "crm_default_team_id", name: "website_crm_default_team_id_fkey", on_delete: :nullify
  add_foreign_key "website", "im_livechat_channel", column: "channel_id", name: "website_channel_id_fkey", on_delete: :nullify
  add_foreign_key "website", "res_company", column: "company_id", name: "website_company_id_fkey", on_delete: :nullify
  add_foreign_key "website", "res_lang", column: "default_lang_id", name: "website_default_lang_id_fkey", on_delete: :nullify
  add_foreign_key "website", "res_users", column: "create_uid", name: "website_create_uid_fkey", on_delete: :nullify
  add_foreign_key "website", "res_users", column: "crm_default_user_id", name: "website_crm_default_user_id_fkey", on_delete: :nullify
  add_foreign_key "website", "res_users", column: "user_id", name: "website_user_id_fkey", on_delete: :nullify
  add_foreign_key "website", "res_users", column: "write_uid", name: "website_write_uid_fkey", on_delete: :nullify
  add_foreign_key "website", "website_page", column: "homepage_id", name: "website_homepage_id_fkey", on_delete: :nullify
  add_foreign_key "website_lang_rel", "res_lang", column: "lang_id", name: "website_lang_rel_lang_id_fkey", on_delete: :cascade
  add_foreign_key "website_lang_rel", "website", name: "website_lang_rel_website_id_fkey", on_delete: :cascade
  add_foreign_key "website_menu", "res_users", column: "create_uid", name: "website_menu_create_uid_fkey", on_delete: :nullify
  add_foreign_key "website_menu", "res_users", column: "write_uid", name: "website_menu_write_uid_fkey", on_delete: :nullify
  add_foreign_key "website_menu", "website", name: "website_menu_website_id_fkey", on_delete: :nullify
  add_foreign_key "website_menu", "website_menu", column: "parent_id", name: "website_menu_parent_id_fkey", on_delete: :cascade
  add_foreign_key "website_menu", "website_page", column: "page_id", name: "website_menu_page_id_fkey", on_delete: :nullify
  add_foreign_key "website_page", "ir_ui_view", column: "view_id", name: "website_page_view_id_fkey", on_delete: :cascade
  add_foreign_key "website_page", "res_users", column: "create_uid", name: "website_page_create_uid_fkey", on_delete: :nullify
  add_foreign_key "website_page", "res_users", column: "write_uid", name: "website_page_write_uid_fkey", on_delete: :nullify
  add_foreign_key "website_redirect", "res_users", column: "create_uid", name: "website_redirect_create_uid_fkey", on_delete: :nullify
  add_foreign_key "website_redirect", "res_users", column: "write_uid", name: "website_redirect_write_uid_fkey", on_delete: :nullify
  add_foreign_key "website_redirect", "website", name: "website_redirect_website_id_fkey", on_delete: :nullify
  add_foreign_key "website_website_page_rel", "website", name: "website_website_page_rel_website_id_fkey", on_delete: :cascade
  add_foreign_key "website_website_page_rel", "website_page", name: "website_website_page_rel_website_page_id_fkey", on_delete: :cascade
  add_foreign_key "wizard_document_page_history_show_diff", "res_users", column: "create_uid", name: "wizard_document_page_history_show_diff_create_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_document_page_history_show_diff", "res_users", column: "write_uid", name: "wizard_document_page_history_show_diff_write_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_ir_model_menu_create", "ir_ui_menu", column: "menu_id", name: "wizard_ir_model_menu_create_menu_id_fkey", on_delete: :cascade
  add_foreign_key "wizard_ir_model_menu_create", "res_users", column: "create_uid", name: "wizard_ir_model_menu_create_create_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_ir_model_menu_create", "res_users", column: "write_uid", name: "wizard_ir_model_menu_create_write_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_merge_faculty", "res_users", column: "create_uid", name: "wizard_merge_faculty_create_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_merge_faculty", "res_users", column: "write_uid", name: "wizard_merge_faculty_write_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_multi_charts_accounts", "account_account_template", column: "transfer_account_id", name: "wizard_multi_charts_accounts_transfer_account_id_fkey", on_delete: :nullify
  add_foreign_key "wizard_multi_charts_accounts", "account_chart_template", column: "chart_template_id", name: "wizard_multi_charts_accounts_chart_template_id_fkey", on_delete: :nullify
  add_foreign_key "wizard_multi_charts_accounts", "account_tax_template", column: "purchase_tax_id", name: "wizard_multi_charts_accounts_purchase_tax_id_fkey", on_delete: :nullify
  add_foreign_key "wizard_multi_charts_accounts", "account_tax_template", column: "sale_tax_id", name: "wizard_multi_charts_accounts_sale_tax_id_fkey", on_delete: :nullify
  add_foreign_key "wizard_multi_charts_accounts", "res_company", column: "company_id", name: "wizard_multi_charts_accounts_company_id_fkey", on_delete: :nullify
  add_foreign_key "wizard_multi_charts_accounts", "res_currency", column: "currency_id", name: "wizard_multi_charts_accounts_currency_id_fkey", on_delete: :nullify
  add_foreign_key "wizard_multi_charts_accounts", "res_users", column: "create_uid", name: "wizard_multi_charts_accounts_create_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_multi_charts_accounts", "res_users", column: "write_uid", name: "wizard_multi_charts_accounts_write_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_op_faculty", "res_users", column: "create_uid", name: "wizard_op_faculty_create_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_op_faculty", "res_users", column: "write_uid", name: "wizard_op_faculty_write_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_op_faculty_employee", "res_users", column: "create_uid", name: "wizard_op_faculty_employee_create_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_op_faculty_employee", "res_users", column: "write_uid", name: "wizard_op_faculty_employee_write_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_op_student", "res_users", column: "create_uid", name: "wizard_op_student_create_uid_fkey", on_delete: :nullify
  add_foreign_key "wizard_op_student", "res_users", column: "write_uid", name: "wizard_op_student_write_uid_fkey", on_delete: :nullify
  add_foreign_key "work_hours", "hr_employee", column: "employee_id", name: "work_hours_employee_id_fkey", on_delete: :nullify
  add_foreign_key "work_hours", "res_users", column: "create_uid", name: "work_hours_create_uid_fkey", on_delete: :nullify
  add_foreign_key "work_hours", "res_users", column: "write_uid", name: "work_hours_write_uid_fkey", on_delete: :nullify
  add_foreign_key "x_lave", "res_users", column: "create_uid", name: "x_lave_create_uid_fkey", on_delete: :nullify
  add_foreign_key "x_lave", "res_users", column: "write_uid", name: "x_lave_write_uid_fkey", on_delete: :nullify
end
