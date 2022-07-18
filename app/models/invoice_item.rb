class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates_presence_of :quantity, :unit_price

  #def empty_invoice
  # some ar method returns all invoices without items
  #  deletes them
  #  call in controller#delete action
  # end
end
