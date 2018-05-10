require 'sinatra'
require 'stripe'

def new
end

def create
  # Amount in cents
  @amount = 500

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => params[:stripeToken]
  )

#parts have been changed

begin 
charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )
rescue Stripe::CardError => e
  erb :Errorstripe
end

end
get '/' do 
  create 
end