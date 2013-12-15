module SessionsHelper
  
  def verified?(user)
    return user.verified?
  end
  
  def correct_user
    @user = User.find(params[:id])
    if (!current_user?(@user))
      redirect_to(root_url)
      flash[:notice] = "Sadece kendi hesabiniz icin ulasabilirsiniz!"
    end
  end
    
  def admin_user
    if(!current_user.admin?)
      redirect_to root_url
      flash[:notice] = "Sayfaya erisim yetkiniz yok!"
    end
  end
  
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def kiraci_user
    if Renter.all.blank?
      flash[:notice] = "Kiracı kayıtlı değil.!"
    else
      @insan = User.find(current_user)
      @daire = Renter.find_by_email(@insan.email )
      return @daire.ap_num unless @daire == nil
    end
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Sayfaya erişmek için giriş yapmanız gerekmektedir."
      end
    end
  
  def signed_in?
    !current_user.nil?
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
