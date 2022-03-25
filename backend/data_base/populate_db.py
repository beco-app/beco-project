from populate_active_prom  import populate_active_prom
from populate_prom import populate_prom
from populate_shops import populate_shops
from populate_transactions import populate_transactions
from populate_users import populate_users
from tools import *

def populate_db(s, nu, np, nap, nt) :
    print('-'*50, '-'*50, '-'*50, "inserting shops", sep='\n')
    populate_shops(s)
    print('-'*50, '-'*50, '-'*50, f"{len(getShop())} shops inserted", "inserting users", sep='\n')
    populate_users(nu)
    print('-'*50, '-'*50, '-'*50, f"{len(getUser())} users inserted", "inserting proms", sep='\n')
    populate_prom(np)
    print('-'*50, '-'*50, '-'*50, f"{len(getPromotion())} proms inserted", "inserting active proms", sep='\n')
    populate_active_prom(nap)
    print('-'*50, '-'*50, '-'*50, f"{len(getActivePromotion())} active proms inserted", "inserting transaction", sep='\n')
    populate_transactions(nt)
    print('-'*50, '-'*50, '-'*50, f"{len(getTransaction())} transactions inserted")

if __name__ == '__main__':
    populate_db('backend/data_base/shops.csv', 1000, 100, 10, 5000)
