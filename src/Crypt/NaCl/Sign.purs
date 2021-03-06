module Crypt.NaCl.Sign
  ( generateSignKeyPair
  , getSignKeyPair
  , getSignKeyPairFromSeed
  , getSignPublicKey
  , getSignSecretKey
  , signDetached
  , signOpen
  , sign
  , verifyDetached
  ) where

import Effect (Effect)
import Data.ArrayBuffer.ArrayBuffer (byteLength)
import Data.ArrayBuffer.Typed (buffer)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Nullable (Nullable, toMaybe)
import Data.Maybe (Maybe(..))
import Prelude
import Unsafe.Coerce (unsafeCoerce)
import Crypt.NaCl.Types
  ( Message
  , SignKeyPair
  , Signature
  , SignedMessage
  , SignPublicKey
  , SignSecretKey
  , SignSeed
  )

-- | Generate a random key pair for signing messages
foreign import generateSignKeyPair :: Effect SignKeyPair

-- | Get the signing keypair for a given `SignSecretKey`
foreign import getSignKeyPair :: SignSecretKey -> SignKeyPair

-- | Get the signing keypair for a given `SignSeed`
foreign import getSignKeyPairFromSeed :: SignSeed -> SignKeyPair

-- | Get the `SignPublicKey` for a given `SignKeyPair`
foreign import getSignPublicKey :: SignKeyPair -> SignPublicKey

-- | Get the `SignSecretKey` for a given `SignKeyPair`
foreign import getSignSecretKey :: SignKeyPair -> SignSecretKey

-- | Sign a `Message` using the given `SignSecretKey`.
-- | Returns the contents of the message, signed, as a `SignedMessage`
foreign import sign :: Message -> SignSecretKey -> SignedMessage

foreign import _signOpen :: SignedMessage -> SignPublicKey -> Nullable Message

-- | Like `sign`, but only returns the `Signature`, not the message contents
foreign import signDetached :: Message -> SignSecretKey -> Signature

-- | Verifies a `Signature`, given the `Message`
foreign import verifyDetached :: Message -> Signature -> Boolean

-- | Varifies the signature contained in a `SignedMessage` against a given
-- | `SignPublicKey`.  Returns `Just Message` if the signature verifies,
-- | or `Nothing` otherwise.
signOpen :: SignedMessage -> SignPublicKey -> Maybe Message
signOpen m s = toMaybe (_signOpen m s)

-- | Constructs a `SignSeed` provided the length is 32 bytes.
mkSignSeed :: Uint8Array -> Maybe SignSeed
mkSignSeed bs
  | 32 == (byteLength $ buffer $ bs) = Just (unsafeCoerce bs)
  | otherwise = Nothing
