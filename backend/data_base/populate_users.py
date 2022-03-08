from tools import *
import random
from hashlib import pbkdf2_hmac

## Definition of users
## Each user has attributes:  
#   username:   str
#   email:      str
#   password:	  str
#   phone:	  str
#   gender:	  char
#   age:	  int
#   zip_code: 	  str
#   diet:	  str
#   becoins:	  double

def next_user():
    def next_username():
        i = 0
        while True:
            i = i + 1
            yield 'user'+str(i)

    def hash_password(pwd, salt):
        return pbkdf2_hmac('sha256', pwd, salt, 10000)

    random.seed(123456789)

    # https://barbend.com/types-of-diets/#PD
    diets = ['No preference', 'Vegan','Carnivore']
    username_gen = next_username()

    while True:
        username    = next(username_gen)
        email       = username + '@email.com'
        password    = hash_password(bin(b'pwd'), 123456789)
        phone       = '6' + str(random.randrange(0,99_999_999)).zfill(8)
        gender      = 'F' if random.uniform(0,1) >= 0.5 else 'M'
        age         = max(int(random.gauss(mu=20,sigma=5)),10)
        zip_code    = '080' + str(random.randint(10,42))
        diet        = diets[random.randint(0,len(diets)-1)]
        becoins     = random.randint(0, 1000)

        user = {
            'username':username, 'email':email, 'password':password, 'phone':phone,
            'gender':gender,     'age':age,     'zip_code':zip_code, 'diet':diet, 'becoins':becoins
        }

        yield user 


if __name__ == '__main__':
    user_gen = next_user()
    for i in range(100):
        temp = next(user_gen)
        print(temp)

