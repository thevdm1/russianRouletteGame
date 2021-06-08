from brownie import accounts, config, rrToken

initial_supply = 1000000000000000000
# token_name = "rrToken"
# token_symbol = "RRT"
# to run this in brownie console: run('1_deploy_token')

def main():
	rr_erc20 = rrToken.deploy(
		initial_supply, {'from': accounts[0]}
		)