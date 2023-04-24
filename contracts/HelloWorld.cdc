 access(all) contract HelloWorld {

    access(all) let greeting: String

    init() {
        self.greeting = "Hello, World!1"
    }

    access(all) fun hello(): String {
        return self.greeting
    }
}

//flow project deploy --network testnet
 