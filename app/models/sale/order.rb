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
        if order_line.price_total > 0
          no_subject = no_subject + order_line.op_subjects.count
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

    def self.course_name(order)
      order_lines = order.order_lines.order(:create_date => :asc)
      courses = []
      order_lines.each do |order_line|
        op_course = order_line.op_course
        unless op_course.nil?
          unless courses.include?(op_course.name)
            courses.append op_course.name
          end
        end
      end
      courses.length() == 0 ? '' : courses.join(",")
    end

    def self.export_all
      @orders = Order.order(:date_order => :asc)
      orders_export = []

      @orders.each do |order|
        order_export = []

        order_export.append Order.company_name(order)
        order_export.append order.name
        order_export.append order.order_mode
        order_export.append Order.course_name(order) 
        order_export.append Order.get_no_subjects(order)
        order_export.append order.date_order.strftime('%d-%m-%Y')
        total_in = Order.total_in(order)
        total_out = Order.total_out(order)
        order_export.append total_in
        order_export.append total_out
        order_export.append(total_out + total_in)
        order_export.append Order.admission_start_date(order).strftime('%d-%m-%Y')

        orders_export.append order_export
      end

      p = Axlsx::Package.new
      wb = p.workbook
      wb.add_worksheet(:name => "Basic Worksheet") do |sheet|
        sheet.add_row ["STT", "Ten TT", "So SO","SO Type", "Courses", "So Level Dong Tien", "Ngay Thu Tien", "So Tien Goc", "So Giam Tru", "So Tien Con Lai", "Ngay Khai Giang"]
        index = 0
        orders_export.each do |order_export|
          index = index + 1
          order_export.unshift(index)
          sheet.add_row order_export
        end
      end
      file_name = 'export.xlsx'
      p.serialize(file_name)
    end
  end
end
