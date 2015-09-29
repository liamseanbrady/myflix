shared_examples 'requires sign in' do
  it 'redirects to the sign in path' do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end
  
shared_examples 'requires admin' do
  it 'redirects to the root path' do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end

  it 'sets the flash danger message' do
    set_current_user
    action
    expect(flash[:danger]).to be_present
  end
end

shared_examples 'tokenable' do
  it 'generates a random token when a user is created' do
    expect(tokenable_object.token).not_to be_blank
  end
end
