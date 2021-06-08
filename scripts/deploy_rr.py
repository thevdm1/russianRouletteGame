from brownie import accounts, config, russianRoulette

# initial_supply = 1000000000000000000
# token_name = "rrToken"
# token_symbol = "RRT"
# to run this in brownie console: run('1_deploy_token')

def main():
	rr_contract = russianRoulette.deploy(
		{'from': accounts[0], 'amount': 10e18}
		)