export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json }
  | Json[]

export interface Database {
  public: {
    Tables: {
      domains: {
        Row: {
          created_at: string
          deleted_at: string | null
          id: string
          name: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          name: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          name?: string
          updated_at?: string
        }
      }
      specs: {
        Row: {
          created_at: string
          deleted_at: string | null
          description: string | null
          domain_id: string
          id: string
          name: string
          owner_id: string
          schema_url: string
          updated_at: string
          version: number
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          description?: string | null
          domain_id: string
          id?: string
          name: string
          owner_id: string
          schema_url: string
          updated_at?: string
          version: number
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          description?: string | null
          domain_id?: string
          id?: string
          name?: string
          owner_id?: string
          schema_url?: string
          updated_at?: string
          version?: number
        }
      }
      user_domains: {
        Row: {
          created_at: string
          domain_id: string
          id: string
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          domain_id: string
          id?: string
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          domain_id?: string
          id?: string
          updated_at?: string
          user_id?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}
