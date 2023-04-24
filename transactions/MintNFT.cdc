import HolidaysNFT from 0xf8d6e0586b0a20c7
// import HolidaysNFT from 0x631e88ae7f1d7c20

transaction() {
    prepare(acct: AuthAccount) {
        let image = "img1"
        let name = "name1"
        if acct.borrow<&HolidaysNFT.Collection>(from: /storage/HolidaysNFTCollection) == nil {
            acct.save(<- HolidaysNFT.createEmptyCollection(), to: /storage/HolidaysNFTCollection)
            acct.link<&HolidaysNFT.Collection{HolidaysNFT.CollectionPublic}>(/public/HolidaysNFTCollection, target: /storage/HolidaysNFTCollection)
        }

        let nftCollection = acct.borrow<&HolidaysNFT.Collection>(from: /storage/HolidaysNFTCollection)!
        
        let nft <- HolidaysNFT.mintNFT(image: image, name: name)
        log(nft.id)
        log(acct.address)
        nftCollection.deposit(token: <- nft)
    }

    execute {
        log("minted NFT")
    }
}

// flow transactions send ./transactions/MintNFT.cdc
 