 import HolidaysNFT from 0xf8d6e0586b0a20c7

pub fun main(): [String] {
    let account: Address = 0xf8d6e0586b0a20c7

    let nftCollection = getAccount(account).getCapability(/public/HolidaysNFTCollection).borrow<&HolidaysNFT.Collection{HolidaysNFT.CollectionPublic}>() ?? panic("NFT Collection doesnt't exist")

    let ref = nftCollection.borrowEntireNFT(id: 0)
    return [ref.image, ref.name]
}
 
 //flow scripts execute ./scripts/1.cdc
 