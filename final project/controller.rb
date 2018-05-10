def new
end

def create
  # Amount in cents
  @amount = 500

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )

#this part is probably going to lead to an error
#without keys i cannot alter

#begin 
# risky code
#rescue 
#error fix
#sends an error message
#end



rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end