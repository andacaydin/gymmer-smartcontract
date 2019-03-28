# GYMMER-smartcontract: Decentralize your Gym-Visits.
see: http://www.gymmer.com for more information on our usecase

GYMMER Smartcontract to use in Ethereum Network. To process all GYM-OWNER, GYM-MEMBER and GYMMER transactions.

# Business Proposition

Blockchain technology and decentralization hits a multitude of business models. The fitness-industry will be revolutionized aswell and demand for more options and ways to form the personal fitness of customers will increase inevitably.

GYMMER prepares it's core business-concept of limitless, borderless gym-visits by moving the most critical part of its infrastructure, the payment-process into the blockchain.

This proof of concept is open-source so any interested reader can have a look at our progress in developing a secure, reliable smart-contract in the ethereum network which can be expanded indefinitely to cater any GYMs with different pricing-models.

As intended by the ethereum foundation ether will only be used to fuel the transaction costs. To pay for a GYM-visit customers will use the GYMMER-Token, which is purchasable in a crypto-exchange like bitmart.com or binance.com or in the GYMMER-shop.

To decide inflationary or deflationary measures a board of GYMMER and GYM executives will form, but all measures will be taken that GYMMER-Smartcontract and the underlying infrastructure is accessible, working and maintainable, without GYMMER itself:

The goal is to write the infrastructure with keeping in mind that a company can be bought up, go bankrupt or stop operations for any reason, but the infrastructure built should survive and thrive.



# Technical overview

## GYM-MEMBER
* GYM-Member needs to have a crypto wallet containing GYMMER-Tokens

Alternatively another app (GYMMER, GYM-specific...) can handle crypto-transactions for the user

* GYM-Member starts checkin-process by sending the starttime and a security (max-day-fee) to the GYMMER-SC

* Checkout-process is triggered also by GYM-MEMBER and GYMMER smartcontract returns overpaid amount to user


## Two main smart-contracts: 

## GYMMER (smartcontract)
* Handles checkin/checkout
* Triggers GYM-OWNER-Smartcontract to receive calculated entrance-fee on checkout
* Defines Interface GYM-OWNER-Smartcontract needs to implement to be used
* Holds list of all GYM-OWNER-Smartcontracts implementing Interface and is expandable indefinitely
* Takes predefined fee and sends GYMMER-Tokens GYM-OWNER-SC, which were beforehand sent by GYM-MEMBER as security
* Sends overpayment back to GYM-MEMBER

## GYM-OWNER (smartcontract)

* Needs to implement interface defined in GYMMER smartcontract
* Calculates fee for user-visit by starttime & endtime or returns a fix-fee, depending on implementation
* Receives GYMMER-Tokens for each visit of user when user checks out




