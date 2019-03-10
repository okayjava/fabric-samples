package main

import (
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

type SimpleAsset struct {
}

type userLedger struct {
	Name     string `json:"name"`     // owner
	pvtData  string `json:"pvtData"`  // secure word
	pvtIndex string `json:"pvtIndex"` // pvtTx id
}

type pvtLedger struct {
	ObjectType string `json:"objType"`  // object action type
	pvtIndex   string `json:"pvtIndex"` // pvtTx id
	pvtOwner   string `json:"pvtOwner"` // owner
	pvtValue   string `json:"pvtValue"` // pvtValue
}

func (t *SimpleAsset) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

func (t *SimpleAsset) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fn, args := stub.GetFunctionAndParameters()

	var result string
	var err error
	switch fn {
	case "initUserLedger":
		return t.initUserLedger(stub, args)
	case "putUserLedger":
		return t.putUserLedger(stub, args)
	case "getUserLedger":
		return t.getUserLedger(stub, args)
	default:
		fmt.Println("Invoke func_name(%s) not found!", fn)
		return shim.Error("Invoke func_name not found!")
	}

	if err != nil {
		return shim.Error(err.Error())
	}

	// Return the result as success payload
	return shim.Success([]byte(result))
}

func (t *SimpleAsset) initUserLedger(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	if len(args) != 2 {
		return shim.Error("initUserLedger func failed!")
	}

	pvtOwn := args[0]          // owner
	pvtIndex := stub.GetTxID() // pvtIndex
	pvtValue := strconv.Itoa(123)

	pvtLedger := pvtLedger{"org1Private", pvtIndex, pvtOwn, pvtValue}
	pvtLedgerJSonBytes, err := json.Marshal(pvtLedger)
	if err != nil {
		return shim.Error("pvtLedgerJSonBytes Mashalling Failed!")
	}

	err = stub.PutPrivateData("org1Private", pvtIndex, pvtLedgerJSonBytes)
	if err != nil {
		fmt.Println("org1Private collection datai is not storage owner!")
	}

	userLedger := &userLedger{pvtOwn, args[1], pvtValue}
	userLedgerJSonBytes, err := json.Marshal(userLedger)
	if err != nil {
		return shim.Error("userLedgerJSonBytes Marshalling Failed!")
	}

	err = stub.PutState(pvtOwn, userLedgerJSonBytes)
	if err != nil {
		return shim.Error("initUserLedger PutState func Failed!")
	}

	return shim.Success(userLedgerJSonBytes)
}

func (t *SimpleAsset) putUserLedger(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	if len(args) != 2 {
		return shim.Error("putUserLedger func failed!")
	}

	pvtOwn := args[0]          // owner
	pvtIndex := stub.GetTxID() // pvtIndex
	pvtValue := strconv.Itoa(123)

	pvtLedger := pvtLedger{"org1Private", pvtIndex, pvtOwn, pvtValue}
	pvtLedgerJSonBytes, err := json.Marshal(pvtLedger)
	if err != nil {
		return shim.Error("pvtLedgerJSonBytes Mashalling Failed!")
	}

	err = stub.PutPrivateData("org1Private", pvtIndex, pvtLedgerJSonBytes)
	if err != nil {
		fmt.Println("org1Private collection datai is not storage owner!")
	}

	userLedger := &userLedger{pvtOwn, args[1], pvtValue}
	userLedgerJSonBytes, err := json.Marshal(userLedger)
	if err != nil {
		return shim.Error("userLedgerJSonBytes Marshalling Failed!")
	}

	err = stub.PutState(pvtOwn, userLedgerJSonBytes)
	if err != nil {
		return shim.Error("putUserLedger PutState func Failed!")
	}

	return shim.Success(userLedgerJSonBytes)
}

func (t *SimpleAsset) getUserLedger(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var userLedgerJson userLedger
	//	var pvtLedgerJson pvtLedger

	if len(args) != 1 {
		return shim.Error("getUserLedger func failed!")
	}

	pvtOwn := args[0]
	userLedgerJSonBytes, err := stub.GetState(pvtOwn)
	if err != nil {
		return shim.Error("getUserLedger GutState func Failed!")
	}

	err = json.Unmarshal([]byte(userLedgerJSonBytes), &userLedgerJson)
	if err != nil {
		return shim.Error("getUserLedger Unmarshal func Failed!")
	}

	pvtLedgerJSonBytes, err := stub.GetPrivateData("org1Private", userLedgerJson.pvtIndex)
	if err != nil {
		return shim.Error("getUserLedger GetPrivateData func Failed!")
	}

	return shim.Success(pvtLedgerJSonBytes)
}

func main() {
	err := shim.Start(new(SimpleAsset))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}
