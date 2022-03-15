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

    for shop in random.choices(shops, k=n):
        shop_id = shop['_id']
        description = "This is a discount."
        becoins = random.randint(100, 300)
        now = time.mktime(date.today().timetuple())
        till = time.mktime((date.today() + timedelta(weeks = random.randint(1,4))).timetuple())
        valid_interval = [now, till]

        prom = {
            'shop_id':shop_id, 'description':description, 'becoins':becoins, 'valid_interval':valid_interval
        }

        yield prom

if __name__ == '__main__':
    proms = prom_gen(100)
    for prom in proms:
        print(setPromotion(prom))
        # print(f'   shop:{getShop(_id=prom["shop_id"])}')
        # print('-'*100)