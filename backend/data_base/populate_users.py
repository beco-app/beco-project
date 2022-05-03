from tools import *
import random
from hashlib import pbkdf2_hmac
from datetime import date, timedelta
import time

## Definition of users
## Each user has attributes:  
#   username:   str
#   email:      str
#   password:	  str
#   phone:	  str
#   gender:	  char
#   birthday:	  int
#   zip_code: 	  str
#   diet:	  str
#   becoins:	  double

def user_gen(n):
    """
    Generator of synthetic users. The random seed is set. 

    INPUT: number of users.

    EXAMPLE:
        >>> users = user_gen(3)
        >>> next(mygenerator)
        {'username':'user1',...}
        >>> next(mygenerator)
        {'username':'user2',...}

        >>> users = user_gen(5)
        >>> list(users)
        [{'username':'user1', ...}, ..., {'username':'user5', ...}]
    """

    def next_username():
        """Generator of user names"""
        i = 0
        while True:
            i = i + 1
            yield 'user' + str(i)

    def hash_password(pwd, salt):
        """
        Return the hashed password.

        INPUT. pwd: str; salf: binary
        OUTPUT. binary.
        """
        return pbkdf2_hmac('sha256', pwd.encode('utf-8'), salt, 10000)

    random.seed(123456789)

    # https://barbend.com/types-of-diets/#PD
    tags = ['Restaurant', 'Bar', 'Supermarket', 'Bakery', 'Vegan food',
            'Beverages', 'Local products', 'Green space', 'Plastic free',
            'Herbalist', 'Second hand', 'Cosmetics', 'Pharmacy', 'Fruits & vegetables', 
            'Recycled material', 'Accessible', 'For children', 'Allows pets']
    username_gen = next_username()
    proms = getPromotion('_id')
    first_birthday = date(1970,1,1)
    last_birthday  = date(2008, 12, 31)

    for _ in range(n):
        username    = next(username_gen)
        email       = username + '@email.com'
        password    = hash_password(username, b'123456789')
        phone       = '8' + str(random.randrange(0,99_999_999)).zfill(8)
        gender      = 'F' if random.uniform(0,1) >= 0.5 else 'M'
        birthday    = time.mktime(
            (min(first_birthday + timedelta(int(random.gauss(mu=365*30, sigma=365*10))), last_birthday)).timetuple()
        )  # for age: max(int(random.gauss(mu=20, sigma=5)), 10)
        zip_code    = '080' + str(random.randint(10,42))
        preferences = random.sample(tags, k=5)
        becoins     = random.randint(0, 1000)
        saved_prom  = random.choices(proms, k=random.randint(0,len(proms))) if len(proms) else []

        user = {
            'username':username, 'email':email,           'password':password, 'phone':phone,
            'gender':gender,     'birthday':birthday,     'zip_code':zip_code, 'preferences':preferences, 
            'becoins':becoins,   'saved_prom':saved_prom
        }

        yield user 


def populate_users(n):
    users = user_gen(n)
    for user in users:
        print(setUser(user))
        # print('-'*100)
        # print(user)

if __name__ == '__main__':
    populate_users(10)

