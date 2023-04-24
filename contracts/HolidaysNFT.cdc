 import NonFungibleToken from 0xf8d6e0586b0a20c7
//  import NonFungibleToken from 0x631e88ae7f1d7c20

pub contract HolidaysNFT: NonFungibleToken {
    pub var totalSupply: UInt64
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub resource NFT: NonFungibleToken.INFT {
        pub let id: UInt64
        pub var image: String
        pub var name: String

        init(image: String, name: String) {
            self.id = HolidaysNFT.totalSupply
            HolidaysNFT.totalSupply = HolidaysNFT.totalSupply + 1
            self.image = image
            self.name = name
        }
    }

    pub resource interface CollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowEntireNFT(id: UInt64): &NFT
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, CollectionPublic {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("NFT doesn't exist")
            emit Withdraw(id: withdrawID, from: self.owner?.address)
            return <- token
        }
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @HolidaysNFT.NFT
            emit Deposit(id: token.id, to: self.owner?.address)
            self.ownedNFTs[token.id] <-! token
        }
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT? ?? panic("Can't find id while borrowing")
        }
        
        pub fun borrowEntireNFT(id: UInt64): &NFT {
            let token = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT? ?? panic("Error borrowing entire NFT")
            return token as! &NFT
        }

        destroy() {
            destroy self.ownedNFTs
        }

        init() {
            self.ownedNFTs <- {}
        }
        
    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    pub fun mintNFT(image: String, name: String): @NFT {
        return <- create NFT(image: image, name: name)
    }

    init() {
        self.totalSupply = 0
    }
}
 