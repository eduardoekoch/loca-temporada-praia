class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :cpf, presence: { message: 'não pode ficar em branco' }, uniqueness: { message: 'Já Cadastrado' }
  validate :cpf_is_valid

  private

  def cpf_is_valid
    blacklist = %w{12345678909, 11111111111, 22222222222, 33333333333, 44444444444, 55555555555, 66666666666, 77777777777, 88888888888, 99999999999, 00000000000, 12345678909}
    value = cpf.scan /[0-9]/
    if value.length == 11
      unless blacklist.member?(value.join)
        value = value.collect{|x| x.to_i}
        sum = 10*value[0]+9*value[1]+8*value[2]+7*value[3]+6*value[4]+5*value[5]+4*value[6]+3*value[7]+2*value[8]
        sum = sum - (11 * (sum/11))
        result = (sum == 0 or sum == 1) ? 0 : 11 - sum
        if result == value[9]
          sum = value[0]*11+value[1]*10+value[2]*9+value[3]*8+value[4]*7+value[5]*6+value[6]*5+value[7]*4+value[8]*3+value[9]*2
          sum = sum - (11 * (sum/11))
          result2 = (sum == 0 or sum == 1) ? 0 : 11 - sum
          return true if result2 == value[10]
        end
      end
    end
    errors.add(:cpf, "#{cpf} Inválido")
  end

end
