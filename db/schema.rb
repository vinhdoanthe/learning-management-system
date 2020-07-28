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

ActiveRecord::Schema.define(version: 2020_07_28_021704) do

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
    t.integer "incoterms_id", comment: "Incoterms"
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
    t.integer "stock_move_id", comment: "Stock Move"
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

  create_table "albums", force: :cascade do |t|
    t.bigint "batch_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch_id"], name: "index_albums_on_batch_id"
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

  create_table "batch_subject_rel", id: false, comment: "RELATION BETWEEN op_batch AND op_subject", force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "subject_id", null: false
    t.index ["batch_id", "subject_id"], name: "batch_subject_rel_batch_id_subject_id_key", unique: true
    t.index ["batch_id"], name: "batch_subject_rel_batch_id_idx"
    t.index ["subject_id"], name: "batch_subject_rel_subject_id_idx"
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

  create_table "checklist_line", id: :serial, comment: "checklist.line", force: :cascade do |t|
    t.string "line_name", null: false, comment: "Name"
    t.integer "responsible_user", null: false, comment: "Responsible User"
    t.integer "create_uid", comment: "Created by"
    t.datetime "create_date", comment: "Created on"
    t.integer "write_uid", comment: "Last Updated by"
    t.datetime "write_date", comment: "Last Updated on"
  end

  create_table "checklist_line_rel", id: false, comment: "RELATION BETWEEN orientation_checklist AND checklist_line", force: :cascade do |t|
    t.integer "orientation_checklist_id", null: false
    t.integer "checklist_line_id", null: false
    t.index ["checklist_line_id"], name: "checklist_line_rel_checklist_line_id_idx"
    t.index ["orientation_checklist_id", "checklist_line_id"], name: "checklist_line_rel_orientation_checklist_id_checklist_line__key", unique: true
    t.index ["orientation_checklist_id"], name: "checklist_line_rel_orientation_checklist_id_idx"
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

  create_table "claim_available_subject_rel", id: false, comment: "RELATION BETWEEN op_admission_claim AND op_subject", force: :cascade do |t|
    t.integer "claim_id", null: false
    t.integer "subject_id", null: false
    t.index ["claim_id", "subject_id"], name: "claim_available_subject_rel_claim_id_subject_id_key", unique: true
    t.index ["claim_id"], name: "claim_available_subject_rel_claim_id_idx"
    t.index ["subject_id"], name: "claim_available_subject_rel_subject_id_idx"
  end

  create_table "claim_from_admission", id: false, comment: "RELATION BETWEEN op_admission_claim AND op_admission", force: :cascade do |t|
    t.integer "claim_id", null: false
    t.integer "admission_id", null: false
    t.index ["admission_id"], name: "claim_from_admission_admission_id_idx"
    t.index ["claim_id", "admission_id"], name: "claim_from_admission_claim_id_admission_id_key", unique: true
    t.index ["claim_id"], name: "claim_from_admission_claim_id_idx"
  end

  create_table "comments", comment: "table comment ve mot noi dung cua nguoi dung", force: :cascade do |t|
    t.text "content", comment: "noi dung comment"
    t.bigint "commented_by"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "batch_id"
    t.integer "conversation_type", limit: 2
    t.bigint "created_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch_id"], name: "index_conversations_on_batch_id"
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

  create_table "course_gen_test_room", id: false, comment: "RELATION BETWEEN generate_student_test_room AND op_course", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "gen_room_id", null: false
    t.index ["course_id", "gen_room_id"], name: "course_gen_test_room_course_id_gen_room_id_key", unique: true
    t.index ["course_id"], name: "course_gen_test_room_course_id_idx"
    t.index ["gen_room_id"], name: "course_gen_test_room_gen_room_id_idx"
  end

  create_table "course_student_test_room_rel", id: false, comment: "RELATION BETWEEN student_test_room AND op_course", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "student_test_room_id", null: false
    t.index ["course_id", "student_test_room_id"], name: "course_student_test_room_rel_course_id_student_test_room_id_key", unique: true
    t.index ["course_id"], name: "course_student_test_room_rel_course_id_idx"
    t.index ["student_test_room_id"], name: "course_student_test_room_rel_student_test_room_id_idx"
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
    t.integer "mautic_id", comment: "Mautic id"
    t.datetime "last_write_time", comment: "Last write Time"
    t.integer "phonecall_count", comment: "Phonecalls"
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
    t.float "duration"
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

