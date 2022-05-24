from tools import *
import random
from datetime import timedelta,date
import time


"""
{
  _id:			ObjectId
  shop_id:		ObjectId
  description:	str
  becoins:		int>0
  valid_interval:	[start,end]
}
"""

def prom_gen(n):
    """
    Generator of promotions for shops.
    The valid time of the promotions are going to be ['now', 'now'+n_weeks], 
                'now' = day of generation
                'n_weeks' = 1,2,3 uniformly.
    """

    shops = getShop()
    
    assert len(shops) > 0

    descriptions = [
        f"10% discount.",
        f"50% discount at apples.",
        f"15% discount if above 30€.",
        f"10€ discount if above 50€.",
        f"20% discount at vegetables.",
        f"15% discount at fruits."
    ]

    for shop in random.choices(shops, k=n):
        shop_id = shop['_id']
        description = random.choice(descriptions)
        becoins = random.randint(100, 300)
        now  = time.mktime((date.today() - timedelta(days = random.randint(0,30))).timetuple()) # Generate a random date in the past
        till = time.mktime((date.today() + timedelta(weeks = random.randint(1,4))).timetuple())
        valid_interval = {'from': now, 'to': till}

        prom = {
            'shop_id':shop_id, 'description':description, 'becoins':becoins, 'valid_interval':valid_interval
        }

        yield prom


def populate_prom(n):
    proms = prom_gen(n)
    for prom in proms:
        print(setPromotion(prom))
        # print(f'   shop:{getShop(_id=prom["shop_id"])}')
        # print('-'*100)

if __name__ == '__main__':
    populate_prom(100)