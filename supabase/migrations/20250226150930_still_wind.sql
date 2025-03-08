/*
  # Create payment records table

  1. New Tables
    - `payment_records`
      - `id` (uuid, primary key)
      - `user_name` (text)
      - `email` (text)
      - `phone` (text)
      - `amount` (numeric)
      - `upi_id` (text)
      - `merchant_name` (text)
      - `created_at` (timestamptz)
      - `user_id` (uuid, references auth.users)

  2. Security
    - Enable RLS on `payment_records` table
    - Add policies for authenticated users to:
      - Insert their own records
      - Read their own records
*/

CREATE TABLE IF NOT EXISTS payment_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  amount numeric NOT NULL,
  upi_id text NOT NULL,
  merchant_name text NOT NULL,
  created_at timestamptz DEFAULT now(),
  user_id uuid REFERENCES auth.users NOT NULL
);

ALTER TABLE payment_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can insert their own payment records"
  ON payment_records
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can read their own payment records"
  ON payment_records
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);