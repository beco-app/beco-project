from populate_active_prom  import populate_active_prom
from populate_prom import populate_prom
from populate_shops import populate_shops
from simulate_transactions import transaction_gen
from populate_users import populate_users
from tools import *

def populate_db(s, nu, np, nap, n_days) :
    print('-'*50, '-'*50, '-'*50, "inserting shops", sep='\n')
    populate_shops(s)
    print('-'*50, '-'*50, '-'*50, f"{len(getShop())} shops inserted", "inserting users", sep='\n')
    populate_users(nu)
    print('-'*50, '-'*50, '-'*50, f"{len(getUser())} users inserted", "inserting proms", sep='\n')
    populate_prom(np)
    print('-'*50, '-'*50, '-'*50, f"{len(getPromotion())} proms inserted", "inserting active proms", sep='\n')
    populate_active_prom(nap)
    print('-'*50, '-'*50, '-'*50, f"{len(getActivePromotion())} active proms inserted", "inserting transaction", sep='\n')
    transaction_gen(n_days=n_days, hard=True, n_hard=5)
    print('-'*50, '-'*50, '-'*50, f"{len(getTransaction())} transactions inserted", sep='\n')

if __name__ == '__main__':
    populate_db(s='backend/data_base/shops.csv', nu=600, np=100, nap=10, n_days=70)
