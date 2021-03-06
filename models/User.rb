class User < Sequel::Model

  plugin :validation_helpers

  one_to_many :uploads

  def before_create
    self.enabled ||= true
    self.joined_at ||= Time.now
    self.takedowns ||= 0
    # If admin attr must be false on new user, why not just set as default in the migration
    # For belt and suspenders approach you could put ina validation as well
    self.admin = false	# Only allow this to be added to an existing user.
    super
  end

  def validate
    super
    validates_presence [:name, :email, :password, :enabled, :takedowns, :admin, :joined_at]
    validates_unique(:name)  { |ds| ds.opts[:where].args.map! { |x| Sequel.function(:lower, x); ds } }
    validates_unique(:email) { |ds| ds.opts[:where].args.map! { |x| Sequel.function(:lower, x); ds } }
    validates_format /@/, :email, :message => 'is not a valid email'
  end

end
