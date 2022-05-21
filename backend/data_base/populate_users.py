from tools import *
import random
from hashlib import pbkdf2_hmac
from datetime import date, timedelta
import time
from collections import Counter
from geopy.geocoders import Nominatim

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
            yield 'user' + str(random.randint(1, 10000000))

    def hash_password(pwd, salt):
        """
        Return the hashed password.

        INPUT. pwd: str; salf: binary
        OUTPUT. binary.
        """
        return pbkdf2_hmac('sha256', pwd.encode('utf-8'), salt, 10000)

    random.seed(123456789)

    def hood2loc(geolocator, hood):
        if hood == "Sant Antoni":
            hood = "Barri " + hood
        loc_obj = geolocator.geocode(hood)
        return [loc_obj.latitude, loc_obj.longitude]

    # https://barbend.com/types-of-diets/#PD
    tags = ['Restaurant', 'Bar', 'Supermarket', 'Bakery', 'Vegan food',
            'Beverages', 'Local products', 'Green space', 'Plastic free',
            'Herbalist', 'Second hand', 'Cosmetics', 'Pharmacy', 'Fruits & vegetables', 
            'Recycled material', 'Accessible', 'For children', 'Allows pets']
    username_gen = next_username()
    proms = getPromotion('_id')
    first_birthday = date(1970,1,1)
    last_birthday  = date(2008, 12, 31)

    # hood distributions
    #geolocator = Nominatim(user_agent="beco")
    all_shops = getShop()
    hoods = [shop["neighbourhood"] for shop in all_shops]
    hood_distribution = Counter(hoods)
    #hood_loc = {}
    #for hood in hood_distribution.keys():
    #    hood_loc[hood] = hood2loc(geolocator, hood)
    hood_loc = {'El Poblenou': [41.400527, 2.2017292], 'Vila de Gràcia': [41.3997257, 2.1520867],
        'Sagrada Família': [41.4034789, 2.174410333009705], "Dreta de l'Eixample": [41.3950373, 2.1672069],
        'Sant Pere, Santa Caterina i la Ribera': [41.3883219, 2.1774107],
        "Camp d'en Grassot i Gràcia Nova": [41.4093317, 2.1623227],
        'Sant Martí de Provençals': [41.4165186, 2.1989683], 'La Verneda i la Pau': [41.4232198, 2.202940152045822],
        'Sant Andreu': [41.43743905, 2.196859449748228], 'Fort Pienc': [41.3959246, 2.1823245],
        'Les Corts': [41.385244, 2.1328626], "L'Antiga Esquerra de l'Eixample": [41.39, 2.155],
        "La Nova Esquerra de l'Eixample": [41.383389, 2.149], 'Sant Antoni': [41.3800525, 2.1633268],
        'Barri Gòtic': [41.3833947, 2.1769119], 'Sants': [41.3753288, 2.1349117], 'Sarrià': [41.399373, 2.1215125],
        'Pedralbes': [41.3901401, 2.112218], 'El Poble Sec': [41.3728061, 2.1619718], 'El Raval': [41.3795176, 2.1683678],
        'Sant Gervasi - Galvany': [41.397806849999995, 2.1433767032885203], 'Hostafrancs': [41.375271, 2.1433563],
        'Provençals del Poblenou': [41.4119484, 2.2041249]}


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
        hood = random.choices(list(hood_distribution.keys()), weights=hood_distribution.values(), k=1)[0]
        location = hood_loc[hood]
        preferences = random.sample(tags, k=5)
        becoins     = random.randint(0, 1000)
        saved_prom  = random.choices(proms, k=random.randint(0,len(proms))) if len(proms) else []

        user = {
            'username':username, 'email':email,           'password':password, 'phone':phone,
            'gender':gender,     'birthday':birthday,     'zip_code':zip_code, 'neighbourhood': hood,
            'location': location, 'preferences':preferences, 'becoins':becoins,   'saved_prom':saved_prom
        }

        yield user 


def populate_users(n, verbose=True):
    users = user_gen(n)
    for user in users:
        if verbose:
            print(setUser(user))
        else:
            setUser(user)
        # print('-'*100)
        # print(user)

if __name__ == '__main__':
    populate_users(100)

