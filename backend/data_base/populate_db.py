from populate_active_prom  import populate_active_prom
from populate_prom import populate_prom
from populate_shops import populate_shops
from populate_transactions import populate_transactions
from populate_users import populate_users


def populate_db(s, nu, np, nap, nt) :
    populate_shops(s)
    populate_users(nu)
    populate_prom(np)
    populate_active_prom(nap)
    populate_transactions(nt)

if __name__ == '__main__':
    populate_db('backend/data_base/shops.csv', 1000, 100, 10, 5000)
