{-# LANGUAGE UnicodeSyntax #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- | ASCII utility functions.
module Text.Ascii
  (
  -- * ASCII checks
    IsAscii(..)
  , isAscii
  , Ascii
  , maybeAscii
  , ascii
  -- * Character properties
  , isControl
  , isPrintable
  , isWhiteSpace
  , isSpaceOrTab
  , isLower
  , isUpper
  , toLower
  , toUpper
  , isAlpha
  , isDigit
  , isNzDigit
  , isAlphaNum
  , fromDigit
  , fromNzDigit
  , unsafeFromDigit
  , isBinDigit
  , isNzBinDigit
  , fromBinDigit
  , fromNzBinDigit
  , unsafeFromBinDigit
  , isOctDigit
  , isNzOctDigit
  , fromOctDigit
  , fromNzOctDigit
  , unsafeFromOctDigit
  , isUpHexDigit
  , isNzUpHexDigit
  , fromUpHexDigit
  , fromNzUpHexDigit
  , unsafeFromUpHexDigit
  , isLowHexDigit
  , isNzLowHexDigit
  , fromLowHexDigit
  , fromNzLowHexDigit
  , unsafeFromLowHexDigit
  , isHexDigit
  , isNzHexDigit
  , fromHexDigit
  , fromNzHexDigit
  , unsafeFromHexDigit
  -- * Byte properties
  , isControl8
  , isPrintable8
  , isWhiteSpace8
  , isSpaceOrTab8
  , isLower8
  , isUpper8
  , toLower8
  , toUpper8
  , isAlpha8
  , isDigit8
  , isNzDigit8
  , isAlphaNum8
  , fromDigit8
  , fromNzDigit8
  , unsafeFromDigit8
  , isBinDigit8
  , isNzBinDigit8
  , fromBinDigit8
  , fromNzBinDigit8
  , unsafeFromBinDigit8
  , isOctDigit8
  , isNzOctDigit8
  , fromOctDigit8
  , fromNzOctDigit8
  , unsafeFromOctDigit8
  , isUpHexDigit8
  , isNzUpHexDigit8
  , fromUpHexDigit8
  , fromNzUpHexDigit8
  , unsafeFromUpHexDigit8
  , isLowHexDigit8
  , isNzLowHexDigit8
  , fromLowHexDigit8
  , fromNzLowHexDigit8
  , unsafeFromLowHexDigit8
  , isHexDigit8
  , isNzHexDigit8
  , fromHexDigit8
  , fromNzHexDigit8
  , unsafeFromHexDigit8
  ) where

import Data.Checked
import Data.Char (ord, chr)
import Data.Word (Word8)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as TS
import qualified Data.Text.Lazy as TL

data IsAscii = IsAscii

instance Property IsAscii Word8 where
  holds _ = (< 128)
  {-# INLINE holds #-}

instance Property IsAscii BS.ByteString where
  holds _ = BS.all isAscii
  {-# INLINE holds #-}

instance Property IsAscii BL.ByteString where
  holds _ = BL.all isAscii
  {-# INLINE holds #-}

instance Property IsAscii Char where
  holds _ = (< 128) . ord
  {-# INLINE holds #-}

instance Property IsAscii α ⇒ Property IsAscii [α] where
  holds _ = all isAscii
  {-# INLINE holds #-}

instance Property IsAscii TS.Text where
  holds _ = TS.all isAscii
  {-# INLINE holds #-}

instance Property IsAscii TL.Text where
  holds _ = TL.all isAscii
  {-# INLINE holds #-}

isAscii ∷ Property IsAscii v ⇒ v → Bool 
isAscii = holds IsAscii
{-# INLINE isAscii #-}

type Ascii α = Checked IsAscii α

-- | Map a character to its ASCII encoding if possible, otherwise
--   return 'Nothing'.
maybeAscii ∷ Char → Maybe Word8
maybeAscii c | isAscii c = Just $ ascii c
             | otherwise = Nothing
{-# INLINABLE maybeAscii #-}

-- | Encode an ASCII character. No checks is performed.
ascii ∷ Char → Word8
ascii = fromIntegral . ord
{-# INLINE ascii #-}

-- | Test if a character is an ASCII control character.
isControl ∷ Char → Bool
isControl c = w < 32 || w == 127
  where w = ord c
{-# INLINE isControl #-}

-- | Test if a character is an ASCII printable character.
isPrintable ∷ Char → Bool
isPrintable c = w >= 32 && w < 127
  where w = ord c
{-# INLINE isPrintable #-}

-- | Test if a character is an ASCII whitespace character.
isWhiteSpace ∷ Char → Bool
isWhiteSpace c = c == ' ' || (w >= 9 && w <= 13)
  where w = ord c
{-# INLINE isWhiteSpace #-}

-- | Test if a character is the SPACE or the TAB character.
isSpaceOrTab ∷ Char → Bool
isSpaceOrTab c = c == ' ' || c == '\t'
{-# INLINE isSpaceOrTab #-}

-- | Test if a character is an ASCII lower-case letter.
isLower ∷ Char → Bool
isLower c = c >= 'a' && c <= 'z'
{-# INLINE isLower #-}

-- | Test if a character is an ASCII upper-case letter.
isUpper ∷ Char → Bool
isUpper c = c >= 'A' && c <= 'Z'
{-# INLINE isUpper #-}

-- | Map lower-case ASCII letters to the corresponding upper-case letters,
--   leaving other characters as is.
toLower ∷ Char → Char
toLower c | isUpper c = chr (ord c + 32)
          | otherwise = c
{-# INLINABLE toLower #-}

-- | Map upper-case ASCII letters to the corresponding lower-case letters,
--   leaving other characters as is.
toUpper ∷ Char → Char
toUpper c | isLower c = chr (ord c - 32)
          | otherwise = c
{-# INLINABLE toUpper #-}

-- | Test if a character is an ASCII letter.
isAlpha ∷ Char → Bool
isAlpha c = isUpper c || isLower c
{-# INLINABLE isAlpha #-}

-- | Test if a character is a decimal digit (/'0' ... '9'/).
isDigit ∷ Char → Bool
isDigit c = c >= '0' && c <= '9'
{-# INLINE isDigit #-}

-- | Test if a character is a non-zero decimal digit (/'1' ... '9'/).
isNzDigit ∷ Char → Bool
isNzDigit c = c >= '1' && c <= '9'
{-# INLINE isNzDigit #-}

-- | Test if a character is either an ASCII letter or a decimal digit.
isAlphaNum ∷ Char → Bool
isAlphaNum c = isDigit c || isAlpha c
{-# INLINABLE isAlphaNum #-}

-- | Map a decimal digit to the corresponding number. Return 'Nothing' on
--   other inputs.
fromDigit ∷ Num a ⇒ Char → Maybe a
fromDigit c | isDigit c = Just $ unsafeFromDigit c
            | otherwise = Nothing
{-# INLINABLE fromDigit #-}

-- | Map non-zero decimal digits to the corresponding numbers. Return
--   'Nothing' on other inputs.
fromNzDigit ∷ Num a ⇒ Char → Maybe a
fromNzDigit c | isNzDigit c = Just $ unsafeFromDigit c
              | otherwise   = Nothing
{-# INLINABLE fromNzDigit #-}

-- | Map decimal digits to the corresponding numbers. No checks is performed.
unsafeFromDigit ∷ Num a ⇒ Char → a
unsafeFromDigit c = fromIntegral (ord c - ord '0')
{-# INLINE unsafeFromDigit #-}

-- | Test if a character is a binary digit (/'0'/ or /'1'/).
isBinDigit ∷ Char → Bool
isBinDigit c = c == '0' || c == '1'
{-# INLINE isBinDigit #-}

-- | Test if a character is the non-zero binary digit (/'1'/).
isNzBinDigit ∷ Char → Bool
isNzBinDigit c = c == '1'
{-# INLINE isNzBinDigit #-}

-- | Map binary digits to the corresponding numbers. Return 'Nothing' on
--   other inputs.
fromBinDigit ∷ Num a ⇒ Char → Maybe a
fromBinDigit c | isBinDigit c = Just $ unsafeFromBinDigit c
               | otherwise    = Nothing
{-# INLINABLE fromBinDigit #-}

-- | Map the digit /'1'/ to the number /1/. Return 'Nothing' on other inputs.
fromNzBinDigit ∷ Num a ⇒ Char → Maybe a
fromNzBinDigit c | isNzBinDigit c = Just 1
                 | otherwise      = Nothing
{-# INLINABLE fromNzBinDigit #-}

-- | Map binary digits to the corresponding numbers. No checks is performed.
unsafeFromBinDigit ∷ Num a ⇒ Char → a
unsafeFromBinDigit = unsafeFromDigit
{-# INLINE unsafeFromBinDigit #-}

-- | Test if a character is an octal digit (/'0' ... '7'/).
isOctDigit ∷ Char → Bool
isOctDigit c = c >= '0' && c <= '7'
{-# INLINE isOctDigit #-}

-- | Test if a character is a non-zero octal digit (/'1' ... '7'/).
isNzOctDigit ∷ Char → Bool
isNzOctDigit c = c >= '1' && c <= '7'
{-# INLINE isNzOctDigit #-}

-- | Map octal digits to the corresponding numbers. Return 'Nothing' on
--   other inputs.
fromOctDigit ∷ Num a ⇒ Char → Maybe a
fromOctDigit c | isOctDigit c = Just $ unsafeFromOctDigit c
               | otherwise    = Nothing
{-# INLINABLE fromOctDigit #-}

-- | Map non-zero octal digits to the corresponding numbers. Return
--   'Nothing' on other inputs.
fromNzOctDigit ∷ Num a ⇒ Char → Maybe a
fromNzOctDigit c | isNzOctDigit c = Just $ unsafeFromOctDigit c
                 | otherwise      = Nothing
{-# INLINABLE fromNzOctDigit #-}

-- | Map octal digits to the corresponding numbers. No checks is performed.
unsafeFromOctDigit ∷ Num a ⇒ Char → a
unsafeFromOctDigit = unsafeFromDigit
{-# INLINE unsafeFromOctDigit #-}

isLowAF ∷ Char → Bool
isLowAF c = c >= 'a' && c <= 'f'
{-# INLINE isLowAF #-}

fromLowAF ∷ Num a ⇒ Char → a
fromLowAF c = fromIntegral (ord c - ord 'a' + 10)
{-# INLINE fromLowAF #-}

-- | Test if a character is a lower-case hexadecimal digit
--   (/'0' ... '9'/ or /'a' ... 'f'/).
isLowHexDigit ∷ Char → Bool
isLowHexDigit c = isDigit c || isLowAF c
{-# INLINABLE isLowHexDigit #-}

-- | Test if a character is a non-zero lower-case hexadecimal digit
--   (/'1' ... '9'/ or /'a' ... 'f'/).
isNzLowHexDigit ∷ Char → Bool
isNzLowHexDigit c = isNzDigit c || isLowAF c
{-# INLINABLE isNzLowHexDigit #-}

-- | Map lower-case hexadecimal digits to the corresponding numbers.
--   Return 'Nothing' on other inputs.
fromLowHexDigit ∷ Num a ⇒ Char → Maybe a
fromLowHexDigit c | isDigit c = Just $ unsafeFromDigit c
                  | isLowAF c = Just $ fromLowAF c
                  | otherwise = Nothing
{-# INLINABLE fromLowHexDigit #-}

-- | Map non-zero lower-case hexadecimal digits to the corresponding numbers.
--   Return 'Nothing' on other inputs.
fromNzLowHexDigit ∷ Num a ⇒ Char → Maybe a
fromNzLowHexDigit c | isNzDigit c = Just $ unsafeFromDigit c
                    | isLowAF c   = Just $ fromLowAF c
                    | otherwise   = Nothing
{-# INLINABLE fromNzLowHexDigit #-}

-- | Map lower-case hexadecimal digits to the corresponding numbers.
--   No checks is performed.
unsafeFromLowHexDigit ∷ Num a ⇒ Char → a
unsafeFromLowHexDigit c | c < 'a'   = unsafeFromDigit c
                        | otherwise = fromLowAF c
{-# INLINE unsafeFromLowHexDigit #-}

isUpAF ∷ Char → Bool
isUpAF c = c >= 'A' && c <= 'F'
{-# INLINE isUpAF #-}

fromUpAF ∷ Num a ⇒ Char → a
fromUpAF c = fromIntegral (ord c - ord 'A' + 10)
{-# INLINE fromUpAF #-}

-- | Test if a character is an upper-case hexadecimal digit
--   (/'0' ... '9'/ or /'A' ... 'F'/).
isUpHexDigit ∷ Char → Bool
isUpHexDigit c = isDigit c || isUpAF c
{-# INLINABLE isUpHexDigit #-}

-- | Test if a character is a non-zero upper-case hexadecimal digit
--   (/'1' ... '9'/ or /'A' ... 'F'/).
isNzUpHexDigit ∷ Char → Bool
isNzUpHexDigit c = isNzDigit c || isUpAF c
{-# INLINABLE isNzUpHexDigit #-}

-- | Map upper-case hexadecimal digits to the corresponding numbers.
--   Return 'Nothing' on other inputs.
fromUpHexDigit ∷ Num a ⇒ Char → Maybe a
fromUpHexDigit c | isDigit c = Just $ unsafeFromDigit c
                 | isUpAF c  = Just $ fromUpAF c
                 | otherwise = Nothing
{-# INLINABLE fromUpHexDigit #-}

-- | Map non-zero upper-case hexadecimal digits to the corresponding numbers.
--   Return 'Nothing' on other inputs.
fromNzUpHexDigit ∷ Num a ⇒ Char → Maybe a
fromNzUpHexDigit c | isNzDigit c = Just $ unsafeFromDigit c
                   | isUpAF c    = Just $ fromUpAF c
                   | otherwise   = Nothing
{-# INLINABLE fromNzUpHexDigit #-}

-- | Map upper-case hexadecimal digits to the corresponding numbers.
--   No checks is performed.
unsafeFromUpHexDigit ∷ Num a ⇒ Char → a
unsafeFromUpHexDigit c | c < 'A'   = unsafeFromDigit c
                       | otherwise = fromUpAF c
{-# INLINE unsafeFromUpHexDigit #-}

-- | Test if a character is a hexadecimal digit
--   (/'0' ... '9'/ or /'a' ... 'f'/ or /'A' ... 'F'/).
isHexDigit ∷ Char → Bool
isHexDigit c = isDigit c || isUpAF c || isLowAF c
{-# INLINABLE isHexDigit #-}

-- | Test if a character is a non-zero hexadecimal digit
--   (/'1' ... '9'/ or /'a' ... 'f'/ or /'A' ... 'F'/).
isNzHexDigit ∷ Char → Bool
isNzHexDigit c = isNzDigit c || isUpAF c || isLowAF c
{-# INLINABLE isNzHexDigit #-}

-- | Map hexadecimal digits to the corresponding numbers.
--   Return 'Nothing' on other inputs.
fromHexDigit ∷ Num a ⇒ Char → Maybe a
fromHexDigit c | isDigit c = Just $ unsafeFromDigit c
               | isUpAF c  = Just $ fromUpAF c
               | isLowAF c = Just $ fromLowAF c
               | otherwise = Nothing
{-# INLINABLE fromHexDigit #-}

-- | Map non-zero hexadecimal digits to the corresponding numbers.
--   Return 'Nothing' on other inputs.
fromNzHexDigit ∷ Num a ⇒ Char → Maybe a
fromNzHexDigit c | isNzDigit c = Just $ unsafeFromDigit c
                 | isUpAF c    = Just $ fromUpAF c
                 | isLowAF c   = Just $ fromLowAF c
                 | otherwise   = Nothing
{-# INLINABLE fromNzHexDigit #-}

-- | Map hexadecimal digits to the corresponding numbers. No checks is
--   performed.
unsafeFromHexDigit ∷ Num a ⇒ Char → a
unsafeFromHexDigit c | c < 'A'   = unsafeFromDigit c
                     | c < 'a'   = fromUpAF c
                     | otherwise = fromLowAF c
{-# INLINE unsafeFromHexDigit #-}

-- | Test if a byte is the encoding of an ASCII control character.
isControl8 ∷ Word8 → Bool
isControl8 w = w < 32 || w == 127
{-# INLINE isControl8 #-}

-- | Test if a byte is the encoding of an ASCII printable character.
isPrintable8 ∷ Word8 → Bool
isPrintable8 w = w >= 32 && w < 127
{-# INLINE isPrintable8 #-}

-- | Test if a byte is the encoding of an ASCII whitespace character.
isWhiteSpace8 ∷ Word8 → Bool
isWhiteSpace8 w = w == ascii ' ' || w >= 9 && w <= 13
{-# INLINE isWhiteSpace8 #-}

-- | Test if a byte is the encoding of the SPACE or the TAB character.
isSpaceOrTab8 ∷ Word8 → Bool
isSpaceOrTab8 w = w == ascii ' ' || w == ascii '\t'
{-# INLINE isSpaceOrTab8 #-}

-- | Test if a byte is the encoding of an ASCII lower-case letter.
isLower8 ∷ Word8 → Bool
isLower8 w = w >= ascii 'a' && w <= ascii 'z'
{-# INLINE isLower8 #-}

-- | Test if a byte is the encoding of an ASCII upper-case letter.
isUpper8 ∷ Word8 → Bool
isUpper8 w = w >= ascii 'A' && w <= ascii 'Z'
{-# INLINE isUpper8 #-}

-- | Map the encodings of lower-case ASCII letters to the encodings of
--   the corresponding upper-case letters, leaving other bytes as is.
toLower8 ∷ Word8 → Word8
toLower8 w | isUpper8 w = w + 32
           | otherwise  = w
{-# INLINABLE toLower8 #-}

-- | Map the encodings of upper-case ASCII letters to the encodings of
--   the corresponding lower-case letters, leaving other bytes as is.
toUpper8 ∷ Word8 → Word8
toUpper8 w | isLower8 w = w - 32
           | otherwise  = w
{-# INLINABLE toUpper8 #-}

-- | Test if a byte is the encoding of an ASCII letter.
isAlpha8 ∷ Word8 → Bool
isAlpha8 w = isUpper8 w || isLower8 w
{-# INLINABLE isAlpha8 #-}

-- | Test if a byte is the encoding of a decimal digit (/'0' ... '9'/).
isDigit8 ∷ Word8 → Bool
isDigit8 w = w >= ascii '0' && w <= ascii '9'
{-# INLINE isDigit8 #-}

-- | Test if a byte is the encoding of a non-zero decimal digit
--   (/'1' ... '9'/).
isNzDigit8 ∷ Word8 → Bool
isNzDigit8 w = w >= ascii '1' && w <= ascii '9'
{-# INLINE isNzDigit8 #-}

-- | Test if a byte is the encoding of either an ASCII letter
--   or a decimal digit.
isAlphaNum8 ∷ Word8 → Bool
isAlphaNum8 w = isDigit8 w || isAlpha8 w
{-# INLINABLE isAlphaNum8 #-}

-- | Map the encoding of a decimal digit to the corresponding number.
--   Return 'Nothing' on other inputs.
fromDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromDigit8 w | isDigit8 w = Just $ unsafeFromDigit8 w
             | otherwise  = Nothing
{-# INLINABLE fromDigit8 #-}

-- | Map the encoding of a non-zero decimal digit to the corresponding number.
--   Return 'Nothing' on other inputs.
fromNzDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromNzDigit8 w | isNzDigit8 w = Just $ unsafeFromDigit8 w
               | otherwise    = Nothing
{-# INLINABLE fromNzDigit8 #-}

-- | Map the encoding of a decimal digit to the corresponding number.
--   No checks is performed.
unsafeFromDigit8 ∷ Num a ⇒ Word8 → a
unsafeFromDigit8 w = fromIntegral (w - ascii '0')
{-# INLINE unsafeFromDigit8 #-}

-- | Test if a byte is the encoding of a binary digit (/'0'/ or /'1'/).
isBinDigit8 ∷ Word8 → Bool
isBinDigit8 w = w == ascii '0' || w == ascii '1'
{-# INLINE isBinDigit8 #-}

-- | Test if a byte is the encoding of the non-zero binary digit (/'1'/).
isNzBinDigit8 ∷ Word8 → Bool
isNzBinDigit8 w = w == ascii '1'
{-# INLINE isNzBinDigit8 #-}

-- | Map the encoding of a binary digit to the corresponding number.
--   Return 'Nothing' on other inputs.
fromBinDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromBinDigit8 w | isBinDigit8 w = Just $ unsafeFromBinDigit8 w
                | otherwise     = Nothing
{-# INLINABLE fromBinDigit8 #-}

-- | Map the encoding of the digit /'1'/ to the number /1/.
--   Return 'Nothing' on other inputs.
fromNzBinDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromNzBinDigit8 w | isNzBinDigit8 w = Just 1
                  | otherwise       = Nothing
{-# INLINABLE fromNzBinDigit8 #-}

-- | Map the encoding of a binary digit to the corresponding number.
--   No checks is performed.
unsafeFromBinDigit8 ∷ Num a ⇒ Word8 → a
unsafeFromBinDigit8 = unsafeFromDigit8
{-# INLINE unsafeFromBinDigit8 #-}

-- | Test if a byte is the encoding of an octal digit (/'0' ... '7'/).
isOctDigit8 ∷ Word8 → Bool
isOctDigit8 w = w >= ascii '0' && w <= ascii '7'
{-# INLINE isOctDigit8 #-}

-- | Test if a byte is the encoding of a non-zero octal digit
--   (/'1' ... '7'/).
isNzOctDigit8 ∷ Word8 → Bool
isNzOctDigit8 w = w >= ascii '1' && w <= ascii '7'
{-# INLINE isNzOctDigit8 #-}

-- | Map the encoding of an octal digit to the corresponding number.
--   Return 'Nothing' on other inputs.
fromOctDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromOctDigit8 w | isOctDigit8 w = Just $ unsafeFromOctDigit8 w
                | otherwise     = Nothing
{-# INLINABLE fromOctDigit8 #-}

-- | Map the encoding of a non-zero octal digit to the corresponding number.
--   Return 'Nothing' on other inputs.
fromNzOctDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromNzOctDigit8 w | isNzOctDigit8 w = Just $ unsafeFromOctDigit8 w
                  | otherwise       = Nothing
{-# INLINABLE fromNzOctDigit8 #-}

-- | Map the encoding of an octal digit to the corresponding number.
--   No checks is performed.
unsafeFromOctDigit8 ∷ Num a ⇒ Word8 → a
unsafeFromOctDigit8 = unsafeFromDigit8
{-# INLINE unsafeFromOctDigit8 #-}

isLowAF8 ∷ Word8 → Bool
isLowAF8 w = w >= ascii 'a' && w <= ascii 'f'
{-# INLINE isLowAF8 #-}

fromLowAF8 ∷ Num a ⇒ Word8 → a
fromLowAF8 w = fromIntegral (w - ascii 'a' + 10)
{-# INLINE fromLowAF8 #-}

-- | Test if a byte is the encoding of a lower-case hexadecimal digit
--   (/'0' ... '9'/ or /'a' ... 'f'/).
isLowHexDigit8 ∷ Word8 → Bool
isLowHexDigit8 w = isDigit8 w || isLowAF8 w
{-# INLINABLE isLowHexDigit8 #-}

-- | Test if a byte is the encoding of a non-zero lower-case hexadecimal digit
--   (/'1' ... '9'/ or /'a' ... 'f'/).
isNzLowHexDigit8 ∷ Word8 → Bool
isNzLowHexDigit8 w = isNzDigit8 w || isLowAF8 w
{-# INLINABLE isNzLowHexDigit8 #-}

-- | Map the encoding of a lower-case hexadecimal digit to the corresponding
--   number. Return 'Nothing' on other inputs.
fromLowHexDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromLowHexDigit8 w | isDigit8 w = Just $ unsafeFromDigit8 w
                   | isLowAF8 w = Just $ fromLowAF8 w
                   | otherwise  = Nothing
{-# INLINABLE fromLowHexDigit8 #-}

-- | Map the encoding of a non-zero lower-case hexadecimal digit to
--   the corresponding number. Return 'Nothing' on other inputs.
fromNzLowHexDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromNzLowHexDigit8 w | isNzDigit8 w = Just $ unsafeFromDigit8 w
                     | isLowAF8 w   = Just $ fromLowAF8 w
                     | otherwise    = Nothing
{-# INLINABLE fromNzLowHexDigit8 #-}

-- | Map the encoding of a lower-case hexadecimal digit to the corresponding
--   number. No checks is performed.
unsafeFromLowHexDigit8 ∷ Num a ⇒ Word8 → a
unsafeFromLowHexDigit8 w | w < ascii 'a' = unsafeFromDigit8 w
                         | otherwise     = fromLowAF8 w
{-# INLINE unsafeFromLowHexDigit8 #-}

isUpAF8 ∷ Word8 → Bool
isUpAF8 w = w >= ascii 'A' && w <= ascii 'F'
{-# INLINE isUpAF8 #-}

fromUpAF8 ∷ Num a ⇒ Word8 → a
fromUpAF8 w = fromIntegral (w - ascii 'A' + 10)
{-# INLINE fromUpAF8 #-}

-- | Test if a byte is the encoding of an upper-case hexadecimal digit
--   (/'0' ... '9'/ or /'A' ... 'F'/).
isUpHexDigit8 ∷ Word8 → Bool
isUpHexDigit8 w = isDigit8 w || isUpAF8 w
{-# INLINABLE isUpHexDigit8 #-}

-- | Test if a byte is the encoding of a non-zero upper-case hexadecimal digit
--   (/'1' ... '9'/ or /'A' ... 'F'/).
isNzUpHexDigit8 ∷ Word8 → Bool
isNzUpHexDigit8 w = isNzDigit8 w || isUpAF8 w
{-# INLINABLE isNzUpHexDigit8 #-}

-- | Map the encoding of an upper-case hexadecimal digit to the corresponding
--   number. Return 'Nothing' on other inputs.
fromUpHexDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromUpHexDigit8 w | isDigit8 w = Just $ unsafeFromDigit8 w
                  | isUpAF8 w  = Just $ fromUpAF8 w
                  | otherwise  = Nothing
{-# INLINABLE fromUpHexDigit8 #-}

-- | Map the encoding of a non-zero upper-case hexadecimal digit to
--   the corresponding number. Return 'Nothing' on other inputs.
fromNzUpHexDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromNzUpHexDigit8 w | isNzDigit8 w = Just $ unsafeFromDigit8 w
                    | isUpAF8 w    = Just $ fromUpAF8 w
                    | otherwise    = Nothing
{-# INLINABLE fromNzUpHexDigit8 #-}

-- | Map the encoding of an upper-case hexadecimal digit to the corresponding
--   number. No checks is performed.
unsafeFromUpHexDigit8 ∷ Num a ⇒ Word8 → a
unsafeFromUpHexDigit8 w | w < ascii 'A' = unsafeFromDigit8 w
                        | otherwise     = fromUpAF8 w
{-# INLINE unsafeFromUpHexDigit8 #-}

-- | Test if a byte is the encoding of a hexadecimal digit
--   (/'0' ... '9'/ or /'a' ... 'f'/ or /'A' ... 'F'/).
isHexDigit8 ∷ Word8 → Bool
isHexDigit8 w = isDigit8 w || isUpAF8 w || isLowAF8 w
{-# INLINABLE isHexDigit8 #-}

-- | Test if a byte is the encoding of a non-zero hexadecimal digit
--   (/'1' ... '9'/ or /'a' ... 'f'/ or /'A' ... 'F'/).
isNzHexDigit8 ∷ Word8 → Bool
isNzHexDigit8 w = isNzDigit8 w || isUpAF8 w || isLowAF8 w
{-# INLINABLE isNzHexDigit8 #-}

-- | Map the encoding of a hexadecimal digit to the corresponding
--   number. Return 'Nothing' on other inputs.
fromHexDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromHexDigit8 w | isDigit8 w = Just $ unsafeFromDigit8 w
                | isUpAF8 w  = Just $ fromUpAF8 w
                | isLowAF8 w = Just $ fromLowAF8 w
                | otherwise  = Nothing
{-# INLINABLE fromHexDigit8 #-}

-- | Map the encoding of a non-zero hexadecimal digit to the corresponding
--   number. Return 'Nothing' on other inputs.
fromNzHexDigit8 ∷ Num a ⇒ Word8 → Maybe a
fromNzHexDigit8 w | isNzDigit8 w = Just $ unsafeFromDigit8 w
                  | isUpAF8 w    = Just $ fromUpAF8 w
                  | isLowAF8 w   = Just $ fromLowAF8 w
                  | otherwise    = Nothing
{-# INLINABLE fromNzHexDigit8 #-}

-- | Map the encoding of a hexadecimal digit to the corresponding
--   number. No checks is performed.
unsafeFromHexDigit8 ∷ Num a ⇒ Word8 → a
unsafeFromHexDigit8 w | w < ascii 'A' = unsafeFromDigit8 w
                      | w < ascii 'a' = fromUpAF8 w
                      | otherwise     = fromLowAF8 w
{-# INLINE unsafeFromHexDigit8 #-}

