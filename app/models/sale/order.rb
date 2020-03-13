module Sale
  class Order < ApplicationRecord
    require 'axlsx'

    self.table_name = 'sale_order'

    has_many :order_lines, foreign_key: :order_id

    belongs_to :res_company, class_name: 'Common::ResCompany', foreign_key: :company_id

    def self.get_no_subjects(order)
      no_subject = 0
      order_lines = order.order_lines.order(:create_date => :asc)
      order_lines.each do |order_line|
        temp_no_subject = order_line.op_subjects.count
        if no_subject < temp_no_subject
          no_subject = temp_no_subject
        end
      end
      no_subject
    end

    def self.total_in(order)
      total_in = 0
      order_lines = order.order_lines.order(:create_date => :asc)
      order_lines.each do |order_line|
        if order_line.price_total > 0
          total_in = total_in + order_line.price_total
        end
      end
      total_in
    end

    def self.total_out(order)
      total_out = 0
      order_lines = order.order_lines.order(:create_date => :asc)
      order_lines.each do |order_line|
        if order_line.price_total < 0
          total_out = total_out + order_line.price_total
        end
      end
      total_out
    end

    def self.admission_start_date(order)
      op_admission = Learning::Batch::OpAdmission.where(sale_order_id: order.id).last
      admission_date = order.date_order
      unless op_admission.nil?
        op_batch = op_admission.op_batch
        unless op_batch.nil?
          if op_batch.start_date.present?
            admission_date = op_batch.start_date
          end
        end
      end
      admission_date
    end

    def self.company_name(order)
      company = order.res_company
      if company.nil?
        'Nil - Holdings'
      else
        company.name
      end
    end

    def self.export_all
      @orders = Order.all.order(:write_date => :asc)
      orders_export = []

      @orders.each do |order|
        order_export = []

        order_export.append Order.company_name(order)
        order_export.append order.name
        order_export.append Order.get_no_subjects(order)
        order_export.append order.date_order
        total_in = Order.total_in(order)
        total_out = Order.total_out(order)
        order_export.append total_in
        order_export.append total_out
        order_export.append(total_out + total_in)
        order_export.append Order.admission_start_date(order)

        orders_export.append order_export
      end
      binding.pry

      p = Axlsx::Package.new
      wb = p.workbook
      wb.add_worksheet(:name => "Basic Worksheet") do |sheet|
        sheet.add_row ["STT", "Ten TT", "So SO", "So Level Dong Tien", "Ngay Thu Tien", "So Tien Goc", "So Giam Tru", "So Tien Con Lai", "Ngay Khai Giang"]
        index = 0
        orders_export.each do |order_export|
          index = index + 1
          order_export.unshift(index)
          sheet.add_row order_export
        end
      end
      file_name = 'export.xlsx'
      p.serialize(file_name)
      binding.pry
    end
  end
end
