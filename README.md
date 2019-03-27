# gymmer-smartcontract
GYMMER Smartcontract to use in Ethereum Network. To process all GYM-OWNER, GYM-MEMBER and GYMMER transactions.

Two main smart-contracts: 

* GYMMER smartcontract
** Handles checkin/checkout
** Triggers GYM-OWNER-Smartcontract to receive entrance-fee
** Defines Interface GYM-OWNER-Smartcontract needs to implement to be used
** Holds list of all GYM-OWNER-Smartcontracts implementing Interface and is expandable indefinitely
** Takes predefined fee and sends GYMMER-Tokens GYM-OWNER-SC, which were beforehand sent by GYM-MEMBER as security
** Sends overpayment back to GYM-MEMBER


* GYM-OWNER smartcontract

** Needs to implement interface defined in GYMMER smartcontract
** Calculates fee for user-visit by starttime & endtime
** Receives GYMMER-Tokens for each visit of user when user checks out


GYM-MEMBER

The GYM-Member starts the checkin-process by sending a security (max-day-fee) to the GYMMER-SC and sending the starttime.
The Checkout-process is triggered also and GYMMER smartcontract returns overpaid amount to user
